# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  username          :string
#  email             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string
#  remember_digest   :string
#  admin             :boolean          default(FALSE)
#  activation_digest :string
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  reset_digest      :string
#  reset_sent_at     :datetime
#


class User < ActiveRecord::Base
  
  attr_accessor :remember_token, :activation_token, :reset_token

  before_validation :strip_downcase_email
  before_validation :update_username_lower
  
  before_create :create_activation_digest

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
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  
  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
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
    UserMailer.password_reset(self).deliver_now
  end
  
  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
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
  
end
