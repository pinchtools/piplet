class Admin::Users::NotificationsController < Admin::AdminController
  include Admin::Users::UsersHelper
  
  before_action :identify_user
  
  def index
    notifications = @user.notifications.order(:created_at => :DESC).paginate(page: params[:page])
    
    render locals: { notifications: notifications }
  end
end
