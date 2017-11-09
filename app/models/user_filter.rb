require_dependency 'ip_addr'
require 'cidr_address'

class UserFilter < ActiveRecord::Base
  include Concerns::Loggable

  before_validation :convert_ip_address, unless: Proc.new { |filter| filter.ip_address.blank? }
  before_save :set_ip_address_to_nil_if_empty
  before_save :set_email_provider_to_nil_if_empty

  validates :email_provider,
    length: { in: 4..100 },
    format: { with: /[a-zA-Z]+\.[a-zA-Z]+\z/ },
    uniqueness: true,
    allow_blank: true
  validate :validate_email_xor_ip
  validate :validate_cidr_address

  validates :ip_address,
    length: { in: 5..50 },
    uniqueness: true,
    allow_blank: true

  scope :all_blocked, -> { where(blocked: true).order(created_at: :desc) }

  private

  def blocked_users

  end

  def validate_email_xor_ip
    unless self.email_provider.present? ^ self.ip_address.present?
      self.errors.add(:base, I18n.t('user-filter.errors.base.email-xor-ip'))
    end
  end

  def validate_cidr_address
    if self.ip_address.present? && self.cidr_address.blank?
      self.errors.add(:ip_address, I18n.t('user-filter.errors.ip_address.invalid'))
    end
  end

  def set_ip_address_to_nil_if_empty
    self.ip_address = nil if ip_address.blank?
  end

  def set_email_provider_to_nil_if_empty
    self.email_provider = nil if email_provider.blank?
  end

  def convert_ip_address
    address = CIDRAddress.create(ip_address)

    self.cidr_address = address.to_s if address.present?
  end

end

# == Schema Information
#
# Table name: user_filters
#
#  id             :integer          not null, primary key
#  email_provider :string
#  ip_address     :string
#  blocked        :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  cidr_address   :inet
#
