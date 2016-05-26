class Users::PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)

      if @user
        @user.create_reset_digest
        @user.send_password_reset_email
        @user.log( :request_password_reset, ip_address: request.remote_ip )
        
        flash[:info] = t('password-reset.notice.info.email-sent')

        redirect_to root_url
    else
      flash.now[:danger] = t('password-reset.notice.danger.email-not-found')
      render 'new'
    end
  end
  
  def edit
    render locals: { user: @user }
  end
  
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      
      @user.log( :password_reset, ip_address: request.remote_ip )
      
      flash[:success] = t('password-reset.notice.success.password-reset')
        
      redirect_to users_dashboard_index_path
    else
      render 'edit'
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&
        @user.authenticated?(:reset, params[:id]))
          redirect_to root_url
       end
    end
    
    
    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = t('password-reset.notice.danger.password-expired')
        redirect_to new_users_password_reset_url
      end
    end
    
end