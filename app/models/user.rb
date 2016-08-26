# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  username              :string
#  email                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  password_digest       :string
#  remember_digest       :string
#  admin                 :boolean          default(FALSE)
#  activation_digest     :string
#  activated             :boolean          default(FALSE)
#  activated_at          :datetime
#  reset_digest          :string
#  reset_sent_at         :datetime
#  username_lower        :string
#  creation_ip_address   :inet
#  activation_ip_address :inet
#  blocked               :boolean          default(FALSE)
#  suspected             :boolean          default(FALSE)
#  suspected_note        :string
#  suspected_by_id       :integer
#  suspected_at          :datetime
#  blocked_by_id         :integer
#  blocked_at            :datetime
#  last_seen_at          :datetime
#  time_zone             :string           default("UTC")
#  description           :text
#  username_renew_count  :integer          default(0)
#  locale                :string
#  deactived             :boolean          default(FALSE)
#  deactivated_at        :datetime
#  delayed_removal       :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_email           (email) UNIQUE
#  index_users_on_username        (username) UNIQUE
#  index_users_on_username_lower  (username_lower) UNIQUE
#

require 'levenshtein'
require 'ip_addr'

class User < ActiveRecord::Base
  include Concerns::Loggable
  include UserConcerns::Roleable
  include UserConcerns::Moderatable
  
  attr_accessor :remember_token, :activation_token, :reset_token
  

  @@MIN_USERNAME_CHARACTERS = 3
  @@MAX_USERNAME_CHARACTERS = 50
  
  @@MIN_PASSWORD_CHARACTERS = 6
  @@MAX_PASSWORD_CHARACTERS = 50
  
  @@REMOVAL_METHOD = nil
  
  enum removal_method: [
    :delay,
    :perform,
    :deactivate
    ]
  
    
  has_and_belongs_to_many :filters, :class_name => 'UserFilter', :join_table => :users_user_filters

  has_many :notifications, dependent: :destroy
  
  has_one :avatar, class_name: 'UserAvatar', dependent: :destroy

  accepts_nested_attributes_for :avatar
  
  before_validation :strip_downcase_email
  before_validation :update_username_lower
  
  before_create :create_activation_digest
  after_create :create_default_avatar
  
  after_create :log_created
  after_create ->{ delay.check_new_account }
  after_create :update_last_seen!
  
  after_commit :notify_username_changed, on: :update, if: :username_updated?

  has_secure_password

  validates :username,
    presence: true, 
    uniqueness: { case_sensitive: false }

  validates :username, username: true
      
  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { maximum: 255 },
    format: { with:  /\A[^@\s]+@[^\@\s\.]+\.[^\@\s]+[^\@\.\s]+\z/ }

  validates :email, email: true
      
  validates :password,
    presence: true,
    allow_nil: true

  validates :password, password: true

  validates :description, length: { maximum: 200 }
  
  validates :creation_ip_address, presence: true
  validates :activation_ip_address, presence: true, if: :activated?
  validates :activated_at, presence: true, if: :activated?

  scope :actives, -> { where( blocked: false, suspected: false ).order( last_seen_at: :desc ) }
  scope :newest, -> { order( created_at: :desc ) }
  
  def self.min_username_characters
    [ Setting['user.min_username_character'].to_i, @@MIN_USERNAME_CHARACTERS ].max
  end
  
  def self.max_username_characters
    @@MAX_USERNAME_CHARACTERS
  end
  
  
  def self.min_password_characters
    [ Setting['user.min_password_character'].to_i, @@MIN_PASSWORD_CHARACTERS].max
  end
  
  def self.max_password_characters
    @@MAX_PASSWORD_CHARACTERS
  end
    
  def self.removal_method
    @@REMOVAL_METHOD = Setting['user.removal_method'] if @@REMOVAL_METHOD.nil?
    
    (User.removal_methods[@@REMOVAL_METHOD].present?) ? @@REMOVAL_METHOD : User.removal_methods.first
  end
  
  def self.removal_delay_duration
    @@REMOVAL_DELAY_DURATION = Setting['user.removal_delay_duration'] if @@REMOVAL_DELAY_DURATION.nil?
    
    @@REMOVAL_DELAY_DURATION
  end
  
  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
      
    return BCrypt::Password.create(string, cost: cost)
  end
  
  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  
  
  def self.search(input)
    if ip = IPAddr.new(input) rescue nil
      where('creation_ip_address <<= :ip', ip: ip.to_cidr_s)
    else
      where('username_lower ILIKE :filter OR email ILIKE :filter', filter: "%#{input}%")
    end
  end
  
    
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # Activates an account.
  def activate(ip_address)
    update_columns(activated: true, 
      activated_at: Time.zone.now,
      activation_ip_address: ip_address
      )
    
    log_activated
  end
  
  # Sends activation email.
  def send_activation_email
    UserMailer.delay.account_activation(self, self.activation_token)
  end
  
  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    
    update_columns(
      reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now
    )
  end
  
  # Sends password reset email.
  def send_password_reset_email
    UserMailer.delay.password_reset(self, self.reset_token)
  end
  
  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  
  def check_new_account
    if blocked_email = find_email_similar_to_blocked_one
      suspect(note: 'user.errors.email.similar-to-blocked-one')
      
      log(:suspected,
        message: 'log.messages.email_similar',
        message_vars: { email: email, bloqued_email: blocked_email }.to_json )
    end
  end
  
  
  def find_email_similar_to_blocked_one
    return false unless Setting['user.suspect_email_similar_to_banned_one']
    
    
    max_distance = Setting['user.considered_email_similar_when_x_characters'] || 2
    
    emails_blocked = User.all_blocked
      .where('blocked_at >  ? ', 7.days.ago)
      .order(:blocked_at => :desc)
      .limit(500)
      .pluck(:email)
      
    return emails_blocked.find{|e| Levenshtein.distance(email, e) <= max_distance}
  end
  
  
  def update_last_seen!(date = Time.current)
    update_column(:last_seen_at, date) unless last_seen_at.present? && date - last_seen_at < 1.minute
  end
  

  def trigger_destroy
    self.send("#{self.removal_method}_destroy")
  end
  
  def delay_destroy
    nb = self.removal_delay_duration.to_i
    
    if duration > 0
      User.find(self.id).delay(duration.days).destroy
      
      #deactivate right now before definitive removal
      deactivate_destroy
      
      log( :delayed_destroy, message_vars: { days: duration } )
    end
    
  end
  
  def perform_destroy
    destroy
  end

  def deactivate_destroy
    update_columns(
      deactivated: true, 
      deactivated_at: Time.zone.now
      )
      
      log( :deactivated )
  end

  
  ########
  #
  # PRIVATE
  #
  ########
  private
  
  def create_default_avatar
    UserAvatar.create(:kind => UserAvatar.kinds[:default], :user_id => self.id)
  end
  
  def strip_downcase_email
    if email.present?
      self.email = email.strip
      self.email = email.downcase
    end
  end
  
  def update_username_lower
    self.username_lower = username.downcase if username.present?
  end
    
  def create_activation_digest
    # Create the token and digest.
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
  
  def username_updated?
    previous_changes.key?(:username) &&
    previous_changes[:username].first != previous_changes[:username].last
  end
  
  def notify_username_changed
    I18n.locale = self.locale if locale.present?
    
    Notification.send_to(self) do |notif|
      notif.title = I18n.t 'notifications.username_change.subject', username: username
      notif.kind = Notification.kinds[:username_changed]
    end
    
    increment!(:username_renew_count)
  end
  
  def log_created
    log( :created, ip_address: creation_ip_address )
  end
  
  def log_activated
    log( :activated, ip_address: activation_ip_address )
  end
  
end
