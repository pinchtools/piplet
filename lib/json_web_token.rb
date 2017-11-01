class JsonWebToken
  ALGORITHM = 'HS256'.freeze

  class << self
    def encode(payload)
      JWT.encode payload, secret, ALGORITHM
    end

    def decode(token, payload_only = true, options = {})
      options.merge!({:algorithm => ALGORITHM})
      decoded_token = JWT.decode token, secret, true, options
      (payload_only) ? decoded_token[0] : decoded_token
    end

    private

    def secret
      Rails.application.secrets.secret_key_base
    end
  end

end
