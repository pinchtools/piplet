class Users::AccountActivationsController < ApplicationController

  def edit
    @user = User.find_by(email: params[:email])
      
    if @user &&
      !@user.activated? &&
      @user.authenticated?(:activation, params[:id])
        @user.activate
        
        log_in @user
        flash[:success] = t('user.notice.success.account-activated')
          
        redirect_to users_user_url(@user)
    else
      flash[:danger] = t('user.notice.danger.invalid-activation-link')
        
      redirect_to root_url
    end
  end


end