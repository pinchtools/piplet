class Users::OmniauthController < ApplicationController


  def complete
    auth = request.env['omniauth.auth']


  end

  def failure

  end
end
