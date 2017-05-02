class Users::SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.all_valid.find_by(email: params[:session][:email].downcase)
      
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
          
        if user.regular?
          redirect_back_or users_dashboard_index_path
        else
          redirect_back_or admin_dashboard_index_path
        end
      else
        flash[:warning] = t('user.notice.warning.account-not-activated')
        redirect_to root_url
      end
    else
      flash.now[:danger] = t('user.notice.danger.invalid-login')
      render 'new'
    end
    
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
end
