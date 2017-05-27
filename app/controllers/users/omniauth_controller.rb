require 'redis_connect'

class Users::OmniauthController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :callback
  before_action :get_completion_cache, only: :complete_profile

  COMPLETION_TOKEN_EXP = 20.minutes.to_i.freeze
  COMPLETION_TOKEN_RETRY = 3.freeze

  def callback
    auth = request.env['omniauth.auth']
    params = request.env['omniauth.params']
    infos = auth.fetch('infos', {})
    from = params.fetch('from', nil)

    account = AuthAccount.find_or_initialize_by(uid: auth['uid'],provider: auth['provider'])

    if account.user.present?
      unless account.user.active?
        account.user.log(:auth_login_fail_not_active)
        flash[:warning] = t('user.notice.warning.account-not-active')
        redirect_to root_url and return
      end

      if from == 'client'
        cookies.permanent[:at] = account.user.api_access_token
        cookies.permanent[:rt] = account.user.api_refresh_token

        render layout: false
      else
        log_in account.user
        render layout: false
      end
    else
      redis = RedisConnect.new
      token = nil
      cache_infos = {
        id: account.id,
        from: from,
        email: infos['email'],
        image_url: infos['image'],
      }

      COMPLETION_TOKEN_RETRY.times do
        token = SecureRandom.hex
        break if redis.add(token, cache_infos, ex: COMPLETION_TOKEN_EXP)
        token = nil
      end

      if token.nil?
        flash[:warning] = t('user.notice.warning.auth-completion-fail-no-token')
        redirect_to root_url and return
      end

      account.update_attributes(name: infos['name'], nickname: infos['nickname'])

      redirect_to auth_complete_profile_url(
                    token: token,
                    auth_email: (infos['email'].present?) ? 1 : 0,
                    auth_img: (infos['image'].present?) ? 1 : 0
                  )
    end


    # Rails.logger.error(request.env['omniauth.params'])

    #auth_accounts
    #provider:string uid:string name:string nickname:string image_url:string registered:boolean

    #test if this auth account has not been used yet by calling a provider callback (request.env['omniauth.auth']['provider'])
    # save info in an auth table, add a flag to known if registration has been completed or not (if it submit a username)

    #ask for a pseudo and email(not required)
    #if provider permit it, ask if we can reuse the avatar

    # then at validation
    # if from is nil set session,refresh the opener then close the window
    # if from eq client write jwt token in cookie, refresh the opener then close the window
  end

  def complete_profile
    #@cache_infos
  end

  def finalize

  end

  def failure

  end

  private

  def get_completion_cache
    redis = RedisConnect.new

    @cache_infos = redis.get(params[:token])
  end
end
