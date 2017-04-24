class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :email, :username, :api_access_token, :api_refresh_token
end
