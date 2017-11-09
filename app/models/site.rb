class Site < ActiveRecord::Base

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3 }
  validates :uid, presence: true, uniqueness: { case_sensitive: false }

  before_validation :generate_uid, if: :new_record?
  after_create :create_default_api_key

  has_many :api_keys, dependent: :destroy

  scope :oldest_first, -> { order( created_at: :desc ) }

  private

  def generate_uid
    self.uid = name.parameterize if name.present?
  end

  def create_default_api_key
    api_keys.create(label: 'default')
  end
end

# == Schema Information
#
# Table name: sites
#
#  id         :integer          not null, primary key
#  name       :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
