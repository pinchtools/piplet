require 'json_web_token'

class ApiController < ActionController::API
  include AbstractController::Helpers
  include Rails.application.routes.url_helpers
  include ActionController::Cookies
  include Api::BaseHelper
  include Api::ResponseHelper

  before_action :authorize_request
  before_action :authenticate_site

  TOKEN_REQUIRED_ATTRS = %w(user exp iat).freeze

  rescue_from Exception, with: :unprocessable_entity_response
  rescue_from JWT::ExpiredSignature, with: :expired_token_response
  rescue_from InvalidToken, with: :invalid_token_response

  private

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

  def authenticate_site
    api_key_record = ApiKey.find_by_public_key(api_key)

    unless site = api_key_record.try(:site)
      throw Exception, I18n.t('site.notice.danger.not_found')
    end

    if api_secret
      throw Exception, I18n.t('site.notice.danger.invalid_secret_key') if api_key_record.secret_key != api_secret
    elsif site.trusted_domains.any?
      throw Exception, I18n.t('site.notice.danger.invalid_domain') if referer_domain.blank? || TrustedDomain.search_by_domain(referer_domain).empty?
    end

    @current_site = site
  end
end
