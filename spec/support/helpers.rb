module Helpers

  def should_redirect_to_login
    expect(response).to redirect_to(login_path)
  end

  def log_in_as(user, options = {})
      # save the current controller
      old_controller = @controller
  
      # use the login controller
      @controller = Users::SessionsController.new
      
      session = { email: user.email, password: user.password }
      
      session[:remember_me] = options[:remember_me] if options[:remember_me].present?
      
      post :create, params: { session: session }
      
      @controller = old_controller
      
      return user
  end
  
end