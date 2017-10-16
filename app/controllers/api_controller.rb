require 'json_web_token'

class ApiController < ActionController::API
  include AbstractController::Helpers
  include Rails.application.routes.url_helpers
  include ActionController::Cookies
  include ApiHelper

  before_action :authorize_request

  TOKEN_REQUIRED_ATTRS = %w(user exp iat).freeze

  rescue_from Exception, with: :unprocessable_entity_response
  rescue_from JWT::ExpiredSignature, with: :expired_token_response
  rescue_from InvalidToken, with: :invalid_token_response

  private

  def render_error(resource, key_code)
    api_code = api_codes(key_code)

    serializer = ActiveModel::Serializer::ErrorSerializer.new(resource)
    adapter = ActiveModelSerializers::Adapter.create(serializer)
    json = adapter.as_json.merge({meta: {code: api_code[:response_code]}})

    render json: json, status: api_code[:http_code]
  end

  def render_success(resource, key_code, **instance_options)
    api_code = api_codes(key_code)
    render json: resource, status: api_code[:http_code], meta: {code: api_code[:response_code]}, **instance_options
  end

  def authorize_request(accept_expiration: false)
    begin
      token_payload = JsonWebToken.decode(access_token)
    rescue JWT::ExpiredSignature
      if accept_expiration
        token_payload = JsonWebToken.decode(access_token, true, verify_expiration: false)
      else
        raise unless accept_expiration
      end
    rescue
      raise InvalidToken, I18n.t('user.notice.danger.invalid-token')
    end
    raise InvalidToken, I18n.t('user.notice.danger.invalid-token') if TOKEN_REQUIRED_ATTRS.any? {|a| token_payload.fetch(a, nil).blank? }

    if client_platform == WEB_CLIENT
      begin
        csrf_payload = JsonWebToken.decode(csrf_token)
        throw Exception if csrf_payload['user'] != token_payload['user']
      rescue
        raise InvalidToken, I18n.t('user.notice.danger.invalid-token')
      end
    end
    @current_user = User.actives.find( token_payload['user'] )
  end

  def invalid_token_response
    user = User.new.tap{|u| u.errors.add(:base, I18n.t('user.notice.danger.invalid-token'))}
    render_error(user, :invalid_token)
  end

  def expired_token_response
    user = User.new.tap{|u| u.errors.add(:base, I18n.t('user.notice.danger.expired-token'))}
    render_error(user, :expired_token)
  end

  def unprocessable_entity_response exception
    user = User.new.tap{|u| u.errors.add(:base, exception.message)}
    render_error(user, :unprocessable_entity)
  end
end
