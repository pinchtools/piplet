require 'rails_helper'

RSpec.describe Admin::Users::PreferencesController, type: :controller do
  include Helpers
  
  describe "GET #index" do
    
    it "redirect to login page if not authorized" do
      get :index, params: { username: 'a' }
      
      should_redirect_to_login
    end
    
    it_behaves_like 'a request by username', :index
    
    it_behaves_like 'a restricted access to admin only' do 
      let(:request) { get :index, params: { username: 'a' } }
    end
  end

end
