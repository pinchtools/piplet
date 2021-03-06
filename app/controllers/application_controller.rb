class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  around_action :set_time_zone, if: :current_user
  
  include Users::SessionsHelper

  private
  
  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t 'user.notice.danger.not-logged'
      redirect_to login_url
    end
  end
  
  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
  
end
