class Users::GenerateCsrfTokenService
  def initialize(user)
    @user = user
  end

  def call
    JsonWebToken.encode({
                          user: @user.id,
                          jti: SecureRandom.base64
                        })
  end
end
