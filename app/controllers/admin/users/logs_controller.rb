class Admin::Users::LogsController < Admin::AdminController
  include Admin::Users::UsersHelper
  
  before_action :identify_user
  
  def index
    logs = LogsDecorator.new( @user.logs.recent.paginate(page: params[:page]) )

    render :locals => { :user => @user, :logs => logs }
  end
  
  def show
    log = Log.find_by_id(params[:id])
    
    render :locals => { :log => LogDecorator.new(log) }
  end
end
