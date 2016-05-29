class Users::UsersController < ApplicationController
  before_action :logged_in_user, only: [ :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :existing_username, only: :show
  before_action :is_regular_user, only: :destroy
  
  def new
    @user = User.new
    @user.build_avatar
    
    render locals: { user: UserDecorator.new(@user) }
  end
  
  def create
    @user = User.new(user_create_params)
    
    @user.creation_ip_address = request.remote_ip
    
    if @user.save
      @user.send_activation_email
      flash[:info] = t 'user.notice.info.account-need-activation'
      redirect_to root_url
    else
      render :new, locals: { user: UserDecorator.new(@user) }
    end
  end
  
  def show

    unless @user.activated?
      redirect_to root_url and return
    end
    
    render locals: { user: UserDecorator.new(@user) }
  end
  
  def edit
    @user.build_avatar if @user.avatar.nil?
    
    render :edit, locals: { user: UserDecorator.new(@user) }
  end
  
  def update
    if @user.update_attributes(user_update_params)
      flash[:success] = t 'user.notice.success.updated'
      redirect_to users_edit_path
    else
      render :edit, locals: { user: UserDecorator.new(@user) }
    end
  end
  
  def destroy
    log_out
    @user.destroy
    flash[:success] = t 'user.notice.success.destroyed'
      
    redirect_to root_path
  end
  
  private
  
  def correct_user
    @user = @current_user
    redirect_to(root_url) unless current_user?(@user)
  end
  
  def existing_username
    @user = User.find_by_username_lower(params[:username])
    redirect_to(root_url) unless @user
  end
  
  def is_regular_user
    redirect_to(users_dashboard_index_url) unless @user.regular?
  end
  
  def user_create_params
    params.require(:user).permit(
      :username, 
      :email,
      :password, 
      :password_confirmation,
      :time_zone,
      :description
      )
  end
  
  def user_update_params
    params.require(:user).permit( 
      :email,
      :password, 
      :password_confirmation,
      :time_zone,
      :description,
      avatar_attributes: [:kind, :uri, :uri_cache]
      )
  end
  
end