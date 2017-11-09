class AuthAccount < ApplicationRecord
  belongs_to :user

  validates :uid, presence: true
  validates :provider, presence: true
  validates :uid, uniqueness: {scope: :provider}

  scope :without_user, -> { where( user_id: nil ) }
end

# == Schema Information
#
# Table name: auth_accounts
#
#  id         :integer          not null, primary key
#  provider   :string(100)
#  uid        :string
#  name       :string
#  nickname   :string
#  image_url  :string
#  email      :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_auth_accounts_on_uid_and_provider  (uid,provider) UNIQUE
#  index_auth_accounts_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
