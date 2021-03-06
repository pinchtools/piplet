class Users::SessionsController < ApplicationController
  include SettingsHelper
  def new
    @fb_enable = setting('global.auth', 'facebook', 'enable') == '1'
    @go_enable = setting('global.auth', 'google', 'enable') == '1'
    @tw_enable = setting('global.auth', 'twitter', 'enable') == '1'
    @auth_enable = [@fb_enable, @go_enable, @tw_enable].any?
  end

  def create
    user = User.all_valid.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      if !user.activated?
        flash[:warning] = t('user.notice.warning.account-not-activated')
        redirect_to root_url and return
      elsif !user.active?
        user.errors.add(:base, I18n.t('user.notice.danger.invalid-login'))
      end
    else
      user ||= User.new
      user.errors.add(:base, I18n.t('user.notice.danger.invalid-login'))
    end

    if user.errors.empty?
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)

      if user.regular?
        redirect_back_or users_dashboard_index_path
      else
        redirect_back_or admin_dashboard_index_path
      end
    else
      flash.now[:danger] = user.errors.full_messages.first
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
