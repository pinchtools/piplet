class Admin::AdminController < ApplicationController
  before_action :logged_in_staff_member
  
  private
  
  def logged_in_staff_member
    unless staff_member?
      store_location
      flash[:danger] = t 'user.notice.danger.not-logged'
      redirect_to login_url
    end
  end
  
end
