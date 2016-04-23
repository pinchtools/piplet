class Admin::Users::UsersController < Admin::AdminController
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
    
    render locals: { users: @users }
  end
  
end