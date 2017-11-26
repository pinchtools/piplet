class ApiKey < ApplicationRecord
  belongs_to :site

  validates :label, presence: true, uniqueness: { case_sensitive: false }
  validates :public_key, presence: true, uniqueness: { case_sensitive: false }
  validates :secret_key, presence: true, uniqueness: { case_sensitive: false }

  before_validation :generate_public_key, if: :generate_public_key?
  before_validation :generate_secret_key, if: :generate_secret_key?

  def generate_public_key
    uuid = nil

    loop do
      uuid = SecureRandom.uuid
      break unless ApiKey.find_by_public_key(uuid)
    end
    self.public_key = uuid
  end

  def generate_secret_key
    self.secret_key = SecureRandom.base64
  end

  private

  def generate_public_key?
    new_record? && public_key.blank?
  end

  def generate_secret_key?
    new_record? && secret_key.blank?
  end
end

# == Schema Information
#
# Table name: api_keys
#
#  id         :integer          not null, primary key
#  label      :string
#  public_key :string
#  secret_key :string
#  site_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_api_keys_on_public_key  (public_key)
#  index_api_keys_on_site_id     (site_id)
#
