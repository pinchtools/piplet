module ApiHelper
  class InvalidToken < StandardError; end

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
      when :no_route_matches
        {http_code: :not_found, response_code: 101}
      when :invalid_key
        {http_code: :unauthorized, response_code: 102}
      when :expired_key
        {http_code: :unauthorized, response_code: 103}
      when :expired_refresh_key
        {http_code: :unprocessable_entity, response_code: 104}
    end
  end
end
