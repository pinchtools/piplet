class RefreshToken < ApplicationRecord
  belongs_to :user
  enum platform: [ :web, :stateless ]

  validates :token, presence: true
  validates :token, uniqueness: { scope: :user_id }
  validates :user_id, presence: true
  validates :platform, presence: true

  scope :all_valid, -> { where(blocked_at: nil) }
end

# == Schema Information
#
# Table name: refresh_tokens
#
#  id             :integer          not null, primary key
#  token          :string
#  platform       :integer
#  user_id        :integer
#  blocked_at     :datetime
#  blocked_reason :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_refresh_tokens_on_token_and_user_id  (token,user_id) UNIQUE
#  index_refresh_tokens_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
