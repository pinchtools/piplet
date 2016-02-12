# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_save :downcase_name
  before_create :create_activation_digest

  has_secure_password

  
  validates :name,
    presence: true, 
    uniqueness: { case_sensitive: false },
    length: { in: 5..50 }

  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX }
      
  validates :password,
    presence: true,
    length: { in: 6..255 },
    allow_nil: true



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
  
  
  private
  
  def downcase_email
    self.email = email.downcase
  end
  
  def downcase_name
      self.name = name.downcase
    end
    
  def create_activation_digest
    # Create the token and digest.
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
  
end