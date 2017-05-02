class AdminConstraint

  def matches?(request)
    @request  = ActionDispatch::Request.new(request.env)
    current_user && current_user.admin?
  end

  
  private 
  
  def current_user
    if (user_id = @request.session[:user_id]) # session exists
      User.actives.find_by(id: user_id)
    elsif (!Rails.env.test? && user_id = @request.cookie_jar.signed[:user_id]) #persistent session exists
      user = User.actives.find_by(id: user_id)
      
      if user && user.authenticated?(:remember, @request.cookies[:remember_token])
        log_in user
        user
      end
      
    end
  end
  
end
