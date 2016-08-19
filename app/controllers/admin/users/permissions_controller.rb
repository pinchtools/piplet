class Admin::Users::PermissionsController < Admin::AdminController
  include Admin::Users::UsersHelper
  
  before_action :identify_user
  
  def index
  end
end
