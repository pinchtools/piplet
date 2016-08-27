class Admin::AdminController < ApplicationController
  before_action :logged_in_admin
  
  private
  
  def logged_in_admin
    unless admin?
      store_location
      flash[:danger] = t 'user.notice.danger.not-logged'
      redirect_to login_url
    end
  end
  
end
