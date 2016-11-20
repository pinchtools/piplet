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

class Site < ActiveRecord::Base

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3 }
  validates :uid, presence: true, uniqueness: { case_sensitive: false }

  before_validation :generate_uid, if: :new_record?

  scope :oldest_first, -> { order( created_at: :desc ) }

  private

  def generate_uid
    self.uid = name.parameterize if name.present?
  end
end
