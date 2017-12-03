class Conversation < ApplicationRecord
  validates :identifier, presence: true, uniqueness: { case_sensitive: false }
  validates :site_id, presence: true

  belongs_to :site
  has_many :pages

  def title
    pages.first.try(:title)
  end
end

# == Schema Information
#
# Table name: conversations
#
#  id         :integer          not null, primary key
#  identifier :string
#  site_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_conversations_on_identifier  (identifier) UNIQUE
#  index_conversations_on_site_id     (site_id)
#
