class Api::V1::ConversationSerializer < ActiveModel::Serializer
  include Api::BaseHelper

  attributes :identifier, :title
end
