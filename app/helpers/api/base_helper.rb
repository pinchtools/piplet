module Api::BaseHelper
  class InvalidToken < StandardError; end

  WEB_CLIENT = 'web'.freeze
  STATELESS_CLIENT = 'stateless'.freeze

  def api_codes(key)
    case key
      when :ok
        {http_code: :ok, response_code: 0}
      when :no_content
        {http_code: :no_content}
      when :created
        {http_code: :created, response_code: 1}
      when :accepted
        {http_code: :accepted, response_code: 2}
      when :unprocessable_entity
        {http_code: :unprocessable_entity, response_code: 100}
      when :not_found
        {http_code: :not_found, response_code: 101}
      when :invalid_token
        {http_code: :unauthorized, response_code: 102}
      when :expired_token
        {http_code: :unauthorized, response_code: 103}
      when :expired_refresh_token
        {http_code: :unprocessable_entity, response_code: 104}
    end
  end

  def client_platform
    @client_platform ||= ([WEB_CLIENT].include?(params[:client_platform])) ? params[:client_platform] : STATELESS_CLIENT
  end

  def access_token
    @access_token ||= if client_platform == WEB_CLIENT
                        cookies[:token].presence
                      elsif request.headers['Authorization'].present?
                        request.headers['Authorization'].split(' ').last
                      end
  end

  def csrf_token
    @csrf_token ||= request.headers['x-csrf-token'].presence
  end

  def api_key
    @api_key ||= request.headers['x-api-key'].presence
  end

  def api_secret
    @api_secret ||= request.headers['x-api-secret'].presence
  end

  def referer_domain
    begin
      uri = URI.parse(request.referer)
    rescue
      uri = URI.parse('')
    end

    @referer_domain ||= uri.host
  end
end
