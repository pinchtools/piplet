require 'redis_connect'

class Users::OmniauthController < ApplicationController
  include ApplicationHelper
  include Users::OmniauthHelper

  skip_before_action :verify_authenticity_token, only: :callback
  before_action :use_cache_infos, only: [:complete_profile, :finalize]

  COMPLETION_TOKEN_EXP = 20.minutes.to_i.freeze
  COMPLETION_TOKEN_RETRY = 3.freeze

  def callback
    auth = request.env['omniauth.auth']
    params = request.env['omniauth.params']
    infos = auth.fetch(:info, {})
    from = params.fetch(:from, nil)

    account = AuthAccount.find_or_initialize_by(uid: auth['uid'],provider: auth['provider'])

    if account.user.present?
      unless account.user.active?
        account.user.log(:auth_login_fail_not_active)
        flash[:warning] = t('user.notice.warning.account-not-activated')
        redirect_to root_url and return
      end

      if from == 'client'
        gain_access_on_client(account.user)
        render layout: false
      else
        log_in account.user
        redirect_to root_url
      end
    elsif account.save
      redis = RedisConnect.new
      token = nil
      cache_infos = {
        id: account.id,
        from: from,
        email: infos[:email],
        img: infos[:image]
      }

      COMPLETION_TOKEN_RETRY.times do
        token = SecureRandom.hex
        break if redis.hadd(token, cache_infos, ex: COMPLETION_TOKEN_EXP)
        token = nil
      end

      if token.nil?
        flash[:danger] = t('user.notice.warning.auth-completion-fail-no-token')
        redirect_to root_url and return
      end

      account.update_attributes(name: infos['name'], nickname: infos['nickname'])

      redirect_to auth_complete_profile_url(
                    token: token,
                    auth_email: (infos['email'].present?) ? 1 : 0,
                    auth_img: (infos['image'].present?) ? 1 : 0
                  )
    else
      redirect_to :auth_failure_url
    end
  end

  def complete_profile
    @username =  (@account.nickname || @account.name).parameterize
    @user = User.new
    render layout: 'empty_hd'
  end

  def finalize
    @username = params[:username]
    password = SecureRandom.base64
    @user = User.new(
      username: @username,
      auth_account: @account,
      creation_ip_address: request.remote_ip,
      creation_domain: request.host + request.port_string,
      locale: detect_language,
      password: password,
      password_confirmation: password
    )

    @user.email = @cache_infos['email'] if params[:use_email] == '1'

    unless @user.save
      render 'complete_profile', layout: 'empty_hd' and return
    end

    @user.activate(request.remote_ip )

    if params[:use_img] == '1'
      @user.avatar = UserAvatar.new( kind: :upload )
      @user.avatar.uri.download!(@cache_infos['img'])
      @user.avatar.save
    end

    if @cache_infos['from'] == 'client'
      gain_access_on_client(@user)
      render 'callback', layout: false
    else
      log_in @account.user

      flash[:success] = t('user.notice.success.first-login', username: @user.username)
      redirect_to root_url
    end
  end

  def failure
    flash[:danger] = t('user.notice.danger.auth-failure')
    redirect_to root_url and return
  end

  private

  def use_cache_infos
    redis = RedisConnect.new

    @cache_infos = redis.hgetall(params[:token])

    unless @cache_infos != nil && @account = AuthAccount.without_user.find_by_id(@cache_infos['id'])
      flash[:warning] = t('user.notice.warning.auth-cache-not-found')
      redirect_to root_url and return
    end
  end
end
