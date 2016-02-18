class Users::UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
    
    
    render locals: { users: @users }
  end
    
  def new
    @user = User.new
    
    render locals: { user: @user }
  end
  
  def create 
    @user = User.new(user_params)
    
    if @user.save
      @user.send_activation_email
      flash[:info] = t 'user.notice.info.account-need-activation'
      redirect_to root_url
    else
      render :new, locals: { user: @user }
    end
  end
  
  def show
    @user = User.find(params[:id])
    
    render locals: { user: @user }
  end
  
  def edit
    render :edit, locals: { user: @user }
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = t 'user.notice.success.updated'
      redirect_to users_user_path(@user)
    else
      render :edit, locals: { user: @user }
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t 'user.notice.success.destroyed'
      
    redirect_to users_users_path
  end
  
  private
  
  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t 'user.notice.danger.not-logged'
      redirect_to login_url
    end
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
  def user_params
    params.require(:user).permit( :name, 
      :email,
      :password, 
      :password_confirmation)
  end
  
  
end
