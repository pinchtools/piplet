class Users::UsersController < ApplicationController
  def new
    @user = User.new
    
    render locals: { user: @user }
  end
  
  def create 
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to users_user_path(@user)
    else
      render :new, locals: { user: @user }
    end
  end
  
  def show
    @user = User.find(params[:id])
    
    render locals: { user: @user }
  end
  
  private
  
  def user_params
    params.require(:user).permit( :name, 
      :email,
      :password, 
      :password_confirmation)
  end
  
  
end
