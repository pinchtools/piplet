class User < ActiveRecord::Base
  validates :name, :email, presence: true
  
  validates :name, length: { in: 5..50 }
  validates :email, length: { maximum: 100 }
  end