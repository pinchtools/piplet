class Api::V1::UserSerializer < ActiveModel::Serializer
  include ApiHelper

  attributes :email, :username
  attribute :api_access_token, unless: :hide_access_token?
  attribute :csrf_token, if: :csrf_token?
  attribute :refresh_token, if: :refresh_token?

  def csrf_token
    instance_options[:csrf_token]
  end

  def refresh_token
    instance_options[:refresh_token]
  end

  def hide_tokens?
    instance_options[:hide_tokens] == true
  end

  def web_platform?
    instance_options[:client_platform] == WEB_CLIENT
  end

  def hide_access_token?
    hide_tokens? || web_platform?
  end

  def refresh_token?
    instance_options[:refresh_token].present?
  end

  def csrf_token?
    instance_options[:csrf_token].present?
  end
end
