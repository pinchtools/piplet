class Api::V1::TokensController < ApiController
  skip_before_action :authorize_request, only: [:create, :update]
  skip_before_action :authenticate_site, only: [:create, :update]
  before_action -> { authorize_request(accept_expiration: true) }, only: :update

  def create
    user = User.actives.find_by(email: params[:email].downcase) if params[:email]

    if user && user.authenticate(params[:password])
      if !user.activated?
        user.errors.add(:base, I18n.t('user.notice.warning.account-not-activated'))
      elsif !user.active?
        user.errors.add(:base, I18n.t('user.notice.danger.invalid-login'))
      end
    else
      user ||= User.new
      user.errors.add(:base, I18n.t('user.notice.danger.invalid-login'))
    end

    if params[:client_platform].blank?
      user.errors.add(:base, I18n.t('user.notice.danger.client-platform-required'))
    end

    if user.errors.any?
      render_error(user, :unprocessable_entity)
    else
      refresh_token = Users::ObtainRefreshTokenService.new(user, client_platform).call
      options = { client_platform: client_platform, refresh_token: refresh_token.try(:token) }

      if client_platform == WEB_CLIENT
        cookies['token'] = { :value => user.api_access_token, :httponly => true }
        options[:csrf_token] = Users::GenerateCsrfTokenService.new(user).call
      end

      render_success(user, :created, **options)
    end
  end

  def update
    unless @current_user.active?
      @current_user.errors.add(:base, I18n.t('user.notice.danger.invalid-user'))
    end

    refresh_token = params[:refresh_token].presence

    if refresh_token && client_platform
      token = @current_user.refresh_tokens.all_valid.where(token: refresh_token, platform: client_platform).first
      @current_user.errors.add(:base, I18n.t('user.notice.danger.invalid-refresh-token')) unless token
    else
      @current_user.errors.add(:base, I18n.t('user.notice.danger.invalid-user'))
    end

    if @current_user.errors.any?
      render_error(@current_user, :unprocessable_entity)
    else
      options = { client_platform: client_platform }

      if client_platform == WEB_CLIENT
        cookies['token'] = { :value => @current_user.api_access_token, :httponly => true }
      end

      render_success(@current_user, :created, **options)
    end
  end
end
