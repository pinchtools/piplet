# == Schema Information
#
# Table name: api_keys
#
#  id         :integer          not null, primary key
#  label      :string
#  public_key :string
#  secret_key :string
#  default    :boolean          default(FALSE)
#  site_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_api_keys_on_public_key  (public_key)
#  index_api_keys_on_site_id     (site_id)
#

class ApiKey < ApplicationRecord
  belongs_to :site

  validates :label, presence: true, uniqueness: { case_sensitive: false }

  before_validation :generate_public_key, if: :new_record?
  before_validation :generate_secret_key, if: :new_record?


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
end
