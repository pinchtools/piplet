# == Schema Information
#
# Table name: user_filters
#
#  id             :integer          not null, primary key
#  email_provider :string
#  ip_address     :string
#  blocked        :boolean
#  trusted        :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class UserFilter < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_user_filters
  
  validates :email_provider,
    length: { in: 4..100 },
    format: { with: /[a-zA-Z]+\.[a-zA-Z]+\z/ },
    uniqueness: true,
    allow_blank: true
  validate :validate_email_xor_ip
  validate :validate_blocked_xor_trusted
  
  validates :ip_address,
    length: { in: 5..50 },
    uniqueness: true,
    allow_blank: true
  
  scope :all_blocked, -> { where(blocked: true) }
  scope :all_trusted, -> { where(trusted: true) }
  
  before_save :set_ip_address_to_nil_if_empty
  before_save :set_email_provider_to_nil_if_empty
  
  after_create -> { delay.apply_to_existing_users }
  
  private
  
  def validate_email_xor_ip
    unless self.email_provider.present? ^ self.ip_address.present?
      self.errors.add(:base, I18n.t(:'user-filter.errors.base.email-xor-ip'))
    end
  end
  
  def validate_blocked_xor_trusted
    unless !!self.trusted ^ !!self.blocked
      self.errors.add(:base, I18n.t(:'user-filter.errors.base.trusted-xor-blocked'))
    end
  end
  
  def set_ip_address_to_nil_if_empty
    self.ip_address = nil if ip_address.blank?
  end

  def set_email_provider_to_nil_if_empty
    self.email_provider = nil if email_provider.blank?
  end
  
end
