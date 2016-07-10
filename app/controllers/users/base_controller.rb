class Users::BaseController < ApplicationController
  
  protected
  
  def use_current_user
    @user = @current_user
  end
  
end
