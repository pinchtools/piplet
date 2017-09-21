require 'json_web_token'

class ApiController < ActionController::API
  include ApiHelper

  before_action :authorize_request

  TOKEN_REQUIRED_ATTRS = %w(user exp iat).freeze

  rescue_from JWT::ExpiredSignature, with: :expired_token_response
  rescue_from Exception, with: :unprocessable_entity_response
  rescue_from InvalidToken, with: :invalid_token_response

  private

  def render_error(resource, status)
    render json: resource, status: status,
           serializer: ActiveModel::Serializer::ErrorSerializer
  end

  def authorize_request
    begin
      token_payload = JsonWebToken.decode(http_auth_header)
    rescue
      raise InvalidToken, I18n.t('user.errors.base.invalid-token')
    end

    raise InvalidToken, I18n.t('user.errors.base.invalid-token') if TOKEN_REQUIRED_ATTRS.any? {|a| token_payload.fetch(a, nil).blank? }

    @current_user = User.find( token_payload['user'] )
  end

  # check for token in `Authorization` header
  def http_auth_header
    if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    else
      raise InvalidToken, I18n.t('user.errors.base.invalid-token')
    end
  end

  def invalid_token_response
    user = User.new.tap{|u| u.errors.add(:base, I18n.t('user.errors.base.invalid-token'))}
    render_error(user, :unauthorized)
  end

  def expired_token_response
    user = User.new.tap{|u| u.errors.add(:base, I18n.t('user.errors.base.expired-token'))}
    render_error(user, :unauthorized)
  end

  def unprocessable_entity_response exception
    user = User.new.tap{|u| u.errors.add(:base, exception.message)}
    render_error(user, :unprocessable_entity)
  end
end
