module Admin::Users::UsersHelper
  
  def identify_user
    @user = User.where(username_lower: params[:username]).first
    
    redirect_to :admin_users_users if @user.nil?
  end
  
end