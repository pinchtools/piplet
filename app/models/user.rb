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
#  deactivated           :boolean          default(FALSE)
#  deactivated_at        :datetime
#  to_be_deleted         :boolean          default(FALSE)
#  to_be_deleted_at      :datetime
#  blocked_note          :string
#  creation_domain       :string
#
# Indexes
#
#  index_users_on_email           (email) UNIQUE
#  index_users_on_username        (username) UNIQUE
#  index_users_on_username_lower  (username_lower) UNIQUE
#

require 'levenshtein'
require 'ip_addr'
require 'json_web_token'

class User < ActiveRecord::Base
  include Concerns::Loggable
  include UserConcerns::Roleable
  include UserConcerns::Moderatable

  attr_accessor :remember_token, :activation_token, :reset_token, :refresh_token


  @@MIN_USERNAME_CHARACTERS = 3
  @@MAX_USERNAME_CHARACTERS = 50

  @@MIN_PASSWORD_CHARACTERS = 6
  @@MAX_PASSWORD_CHARACTERS = 50

  @@SETTINGS = {}

  ACCESS_TOKEN_DURATION = 30.freeze #minutes

  has_and_belongs_to_many :filters, :class_name => 'UserFilter', :join_table => :users_user_filters

  has_many :notifications, dependent: :destroy

  has_one :avatar, class_name: 'UserAvatar', dependent: :destroy
  has_one :auth_account, dependent: :destroy

  has_many :refresh_tokens, dependent: :destroy

  accepts_nested_attributes_for :avatar

  before_validation :strip_downcase_email
  before_validation :update_username_lower

  before_create :create_activation_digest
  after_create :create_default_avatar

  after_create :log_created
  after_create :check_new_account
  after_create :send_activation_email
  after_create :update_last_seen!

  after_commit :notify_username_changed, on: :update, if: :username_updated?

  has_secure_password

  validates :username,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :username, username: true

  validates :email, uniqueness: { case_sensitive: false, allow_nil: true }
  validates :email, email: true
  validate :email_presence

  validates :password, password: true
  validates :password_confirmation, presence: true, :if => :password_digest_changed?

  validates :description, length: { maximum: 200 }

  validates :creation_ip_address, presence: true
  validates :activation_ip_address, presence: true, if: :activated?
  validates :activated_at, presence: true, if: :activated?

  scope :all_valid, -> { where( blocked: false, deactivated: false ) }
  scope :actives, -> { all_valid.where( activated: true ).order( last_seen_at: :desc ) }
  scope :all_deactivated, -> { where( deactivated: true, to_be_deleted:false).order( deactivated_at: :desc ) }
  scope :all_to_be_deleted, -> { where( to_be_deleted: true ).order( to_be_deleted_at: :asc ) }
  scope :deletion_ready, -> { where( to_be_deleted: true ).where('to_be_deleted_at <= ?', Time.zone.now) }
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

  def self.method_missing(method_name, *arguments, &block)

    if method_name =~ /\A(\w+)=\z/ && Setting.defaults.key?("user.#{$1}")
      # affectation
      self.settings[$1.to_sym] = arguments[0]

      Setting["user.#{$1}"] = arguments[0]
      return
    elsif Setting.defaults.key?("user.#{method_name}")
      # undefined method should ask for setting
      return self.settings[method_name] if self.settings.key?(method_name)

      #when not already set search in db or yml
      self.settings[method_name] = Setting["user.#{method_name}"]

      return self.settings[method_name]
    end

    super
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
    return unless self.auth_account.nil?
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
    User::CheckNewAccountWorker.perform_async(id)
  end

  def find_email_similar_on_scope(scope)
    max_distance = Setting['user.considered_email_similar_when_x_characters'] || 2

    user = User.send(scope).find_each.find{|user| Levenshtein.distance(email, user.email) <= max_distance}

    return user.try(:email)
  end

  def find_username_similar_on_scope(scope)
    max_distance = Setting['user.considered_username_similar_when_x_characters'] || 2

    user = User.send(scope).find_each.find{|user| Levenshtein.distance(username, user.username) <= max_distance}

    return user.try(:username)
  end

  def update_last_seen!(date = Time.current)
    update_column(:last_seen_at, date) unless last_seen_at.present? && date - last_seen_at < 1.minute
  end

  def removable_suspected_user?
    suspected? && deactivated? && User.is_suspect_user_removable
  end

  def removable_blocked_user?
    blocked? && deactivated? && User.is_blocked_user_removable
  end


  def removable?
    return false if !deactivated? # can't remove data if not deactivated previously
    return true unless suspected? || blocked?
    return true if removable_suspected_user?
    return true if removable_blocked_user?
    return false
  end

  def destroy
    if !deactivated?
      self.delay_destroy
    elsif removable?
      super
    end
  end

  def delay_destroy
    deactivate

    nb = User.removal_delay_duration.to_i

    if nb > 0 && removable?
      update_columns(
        to_be_deleted: true,
        to_be_deleted_at: nb.days.from_now
      )

      log( :delayed_destroy, message_vars: { days: nb } )
    end

  end

  def deactivate
    update_columns(
      deactivated: true,
      deactivated_at: Time.zone.now
      )

      log( :deactivated )
  end

  def revert_removal
    # /!\ conds order have importance here
    # has to_be_deleted user also have deactivated status
    if to_be_deleted?
      revert_delayed_deletion
    elsif deactivated?
      revert_deactivation
    end
  end

  def revert_deactivation
    update_columns(
      deactivated: false,
      deactivated_at: nil
    )

    log( :revert_deactivation )
  end

  def revert_delayed_deletion
    update_columns(
      to_be_deleted: false,
      to_be_deleted_at: nil,
      deactivated: false,
      deactivated_at: nil
    )

    log( :revert_deletion )
  end

  def api_access_token
    JsonWebToken.encode({
                            iat: Time.current.to_i,
                            exp: access_token_duration,
                            user: id,
                            jti: SecureRandom.base64(8)
                        })
  end

  def active?
    activated? && !deactivated? && !blocked? && !filters.all_blocked.exists?
  end

  ########
  #
  # PRIVATE
  #
  ########
  private

  def email_presence
    unless self.auth_account || !self.email.blank?
      # 'activerecord.errors.messages.blank'
      self.errors.add :email, :blank
    end
  end

  def self.settings
    @@SETTINGS
  end

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

  def access_token_duration
    ACCESS_TOKEN_DURATION.minutes.after.to_i
  end
end
