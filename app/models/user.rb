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
#  blocked               :boolean
#  suspected             :boolean
#  suspected_note        :string
#  suspected_by_id       :integer
#  suspected_at          :datetime
#  blocked_by_id         :integer
#  blocked_at            :datetime
#
# Indexes
#
#  index_users_on_email           (email) UNIQUE
#  index_users_on_username        (username) UNIQUE
#  index_users_on_username_lower  (username_lower) UNIQUE
#

require 'levenshtein'

class User < ActiveRecord::Base
  include UserConcerns::Loggable
  include UserConcerns::Roleable
  include UserConcerns::Moderatable
  
  attr_accessor :remember_token, :activation_token, :reset_token

  before_validation :strip_downcase_email
  before_validation :update_username_lower
  
  before_create :create_activation_digest
  
  after_create :log_created
  after_create ->{ delay.check_new_account }

  has_secure_password

  validates :username,
    presence: true, 
    uniqueness: { case_sensitive: false },
    length: { in: 5..50 }

  validates :username, username: true
      
  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { maximum: 255 },
    format: { with:  /@/ }

  validates :email, email: true
      
  validates :password,
    presence: true,
    length: { in: 6..255 },
    allow_nil: true

  validates :password, password: true

  validates :creation_ip_address, presence: true
  validates :activation_ip_address, presence: true, if: :activated?
  validates :activated_at, presence: true, if: :activated?

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
        message: 'user-log.messages.email_similar',
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
  
  
  ########
  #
  # PRIVATE
  #
  ########
  private
  
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
  
  def log_created
    log( :created, ip_address: creation_ip_address )
  end
  
  def log_activated
    log( :activated, ip_address: activation_ip_address )
  end
  
end
