class Admin::Users::LogsController < Admin::AdminController
  include Admin::Users::UsersHelper
  
  before_action :identify_user
  
  def index
    logs = LogsDecorator.new( @user.logs.paginate(page: params[:page]) )

    render :locals => { :logs => logs }
  end
end
