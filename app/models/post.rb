class Post < ApplicationRecord
  extend FriendlyId

  belongs_to :user
  belongs_to :conversation

  validates :message, presence: true
  validates :user_id, presence: true
  validates :conversation_id, presence: true
  validates :slug, presence: true

  friendly_id :message, :use => :slugged

  SLUG_LIMIT = 50.freeze

  scope :recents_first, -> { order(created_at: :desc) }

  def normalize_friendly_id(string)
    super.truncate(SLUG_LIMIT, separator: /\s/, omission: '')
  end
end

# == Schema Information
#
# Table name: posts
#
#  id              :integer          not null, primary key
#  message         :text             not null
#  slug            :string           not null
#  user_id         :integer          not null
#  conversation_id :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_posts_on_conversation_id  (conversation_id)
#  index_posts_on_created_at       (created_at)
#  index_posts_on_slug             (slug) UNIQUE
#  index_posts_on_user_id          (user_id)
#
