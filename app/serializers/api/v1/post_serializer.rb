class Api::V1::PostSerializer < ActiveModel::Serializer
  include Api::BaseHelper

  attributes :message, :slug

  belongs_to :user
end
