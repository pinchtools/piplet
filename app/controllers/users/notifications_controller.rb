class Users::NotificationsController < Users::BaseController
  before_action :logged_in_user
  before_action :use_current_user
  
  def index
    notifications = @user.notifications.order(:created_at => :DESC).paginate(page: params[:page])
    
    render locals: { notifications: notifications }
  end
end
