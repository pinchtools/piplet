require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  include Helpers
  
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
  
  
  describe "POST #create" do
    
    it "fails with bad entries" do
      user = create(:user)
      
      user.email = Faker::Internet.email
      user.password = 'foobar'
      
      log_in_as(user)
        
      expect(response).to have_http_status(:ok)
    end
    
    it "fails if user is not activated" do
      user = create(:user)
      
      user.update_attribute(:activated, false)
      
      log_in_as(user)
      
      expect(response).to redirect_to(:root)
      expect(flash[:warning]).to be_present
    end
    
    it "fails if user is blocked" do
      user = create(:user_blocked)
      
      log_in_as(user)
      
      expect(response).to have_http_status(:ok)
      expect(flash[:danger]).to be_present
    end
    
    it "create a regular session when suceed" do
      user = create(:user)
    
      log_in_as(user)
      
      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to( users_dashboard_index_path )
    end
    
    it "create an admin session when suceed" do
      user = create(:admin)
    
      log_in_as(user)
      
      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to( admin_dashboard_index_path )
    end
    
    it 'generate cookies if remember me is checked' do
      expect(cookies).to_not have_key(:remember_token)
      expect(cookies).to_not have_key(:user_id)
      
      user = create(:user)
    
      log_in_as(user, { remember_me: '1' })
      
      expect(cookies).to have_key(:remember_token)
      expect(cookies).to have_key(:user_id)
  end
    
    it 'destroy existing cookies if remember me is unchecked' do
      user = create(:user)
    
      log_in_as(user, { remember_me: '1' })
      
      expect(cookies).to have_key(:remember_token)
      expect(cookies).to have_key(:user_id)
      
      log_in_as(user)
      
      expect(cookies).to_not have_key(:remember_token)
      expect(cookies).to_not have_key(:user_id)
    end
    
  end
  
  describe "DELETE #destroy" do
    
    it 'destroy cookies' do
      user = create(:user)
    
      log_in_as(user, { remember_me: '1' })
      
      expect(cookies).to have_key(:remember_token)
      expect(cookies).to have_key(:user_id)
      
      delete :destroy
      
      expect(cookies).to_not have_key(:remember_token)
      expect(cookies).to_not have_key(:user_id)
    end
  end
  
  

end
