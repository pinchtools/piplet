class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :email, :username
  attribute :api_access_token, unless: :hide_tokens?
  attribute :api_refresh_token, unless: :hide_tokens?

  def hide_tokens?
    instance_options[:hide_tokens] == true
  end
end
