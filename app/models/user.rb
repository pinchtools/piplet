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
    length: { in: 6..255 }

      
    before_save { email.downcase! }
    before_save { name.downcase! }
      
    has_secure_password

end