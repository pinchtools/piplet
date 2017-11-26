class Api::V1::UsersController < ApiController
  include ApplicationHelper
  skip_before_action :authorize_request, only: :create
  skip_before_action :authenticate_site, only: [:create, :update, :show]

  def create
    @user = User.new( user_create_params.merge({
                                                    creation_ip_address: request.remote_ip,
                                                    creation_domain: request.host + request.port_string,
                                                    locale: detect_language
                                                  }) )

    if Users::ConcernedByFiltersService.new(@user).call
      @user.errors.add(:base, I18n.t('user.notice.danger.invalid-login'))
    elsif params[:client_platform].blank?
      @user.errors.add(:base, I18n.t('user.notice.danger.client-platform-required'))
    end

    if @user.errors.empty? && @user.save
      refresh_token = Users::ObtainRefreshTokenService.new(@user, client_platform).call
      options = { client_platform: client_platform, refresh_token: refresh_token.try(:token) }

      if client_platform == WEB_CLIENT
        cookies['token'] = { :value => @user.api_access_token, :httponly => true }
        options[:csrf_token] = Users::GenerateCsrfTokenService.new(@user).call
      end

      render_success(@user, :created, **options)
    else
      render_error(@user, :unprocessable_entity)
    end
  end

  def update
    unless @current_user.active?
      @current_user.errors.add(:base, I18n.t('user.notice.danger.invalid-login'))
    end

    if @current_user.errors.empty? && @current_user.update_attributes(user_update_params)
      render_success(@current_user, :ok, hide_tokens: true)
    else
      render_error(@current_user, :unprocessable_entity)
    end
  end

  def show
    render_success(@current_user, :ok)
  end

  private

  def user_create_params
    params.permit(
        :username,
        :email,
        :password,
        :password_confirmation,
        :time_zone
    )
  end

  def user_update_params
    params.permit(
      :username,
      :email,
      :password,
      :password_confirmation,
      :time_zone,
      :locale,
      :description
    )
  end
end
