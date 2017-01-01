# == Schema Information
#
# Table name: sites
#
#  id         :integer          not null, primary key
#  name       :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  api_uid    :string
#  api_key    :string
#
# Indexes
#
#  index_sites_on_api_uid  (api_uid)
#

class Site < ActiveRecord::Base

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3 }
  validates :uid, presence: true, uniqueness: { case_sensitive: false }

  before_validation :generate_uid, if: :new_record?
  before_validation :generate_api_uid, if: :new_record?
  before_validation :generate_api_key, if: :new_record?

  scope :oldest_first, -> { order( created_at: :desc ) }

  private

  def generate_uid
    self.uid = name.parameterize if name.present?
  end

  def generate_api_uid
    uuid = nil

    loop do
      uuid = SecureRandom.uuid
      break unless Site.find_by_api_uid(uuid)
    end
    self.api_uid = uuid
  end

  def generate_api_key
    self.api_key = SecureRandom.base64
  end

end