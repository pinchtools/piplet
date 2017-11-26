module Users::OmniauthHelper
  include Api::BaseHelper

  def gain_access_on_client(user)
    cookies[:token] = { :value => user.api_access_token, :httponly => true }

    @refresh_token = Users::ObtainRefreshTokenService.new(user, ApiHelper::WEB_CLIENT).call
    @csrf_token = Users::GenerateCsrfTokenService.new(user).call
  end
end
