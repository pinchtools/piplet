require 'rails_helper'

RSpec.describe Admin::Users::UsersController, type: :controller do
  include Helpers
  
  describe "GET #index" do 
    it "redirect to login page if not authorized" do
      get :index
      
      should_redirect_to_login
    end
  end

end
