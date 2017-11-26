class Page < ApplicationRecord
  validates :url, presence: true, uniqueness: { case_sensitive: false }
  validates :title, presence: true
  validates :conversation_id, presence: true

  belongs_to :conversation
end

# == Schema Information
#
# Table name: pages
#
#  id              :integer          not null, primary key
#  url             :string
#  title           :string
#  locale          :string
#  conversation_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_pages_on_conversation_id  (conversation_id)
#  index_pages_on_title            (title)
#  index_pages_on_url              (url) UNIQUE
#
