require 'rails_helper'

RSpec.describe Admin::Users::LogsController, type: :controller do
  include Helpers
  
  describe "GET #index" do
    
    it "redirect to login page if not authorized" do
      get :index, username: 'a'
      
      should_redirect_to_login
    end
    
    it_behaves_like 'a request by username', :index
    
  end

end
