class Api::V1::ConversationSerializer < ActiveModel::Serializer
  include Api::BaseHelper

  attributes :identifier, :title

  has_many :posts, serializer: Api::V1::PostSerializer do
    link(:related) { api_v1_posts_path(user_id: object.id) }
  end
end
