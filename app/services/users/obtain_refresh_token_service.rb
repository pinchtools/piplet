class Users::ObtainRefreshTokenService
  def initialize(user, client_platform)
    @user = user
    @client_platform = client_platform
  end

  def call
    existing_token || generate_token
    # record = generate_token unless record
    #test record is always return
  end

  private
  def existing_token
    RefreshToken.all_valid.where(user: @user, platform: @client_platform).first
  end

  def generate_token
    RefreshToken.create(user: @user, platform: @client_platform, token: SecureRandom.base64)
  rescue ActiveRecord::RecordNotUnique
    generate_token
  end
end
