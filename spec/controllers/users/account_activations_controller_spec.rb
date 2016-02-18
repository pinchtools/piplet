require 'rails_helper'

RSpec.describe Users::AccountActivationsController, type: :controller do
  include Helpers
  
  describe "GET #edit" do 
    let(:user) { user = build(:user) }
    before(:each) {
      user.update_attribute(:activated, false)
    }
      
    it "should activate account a new user" do
      
      
      get :edit, { :id => user.activation_token,
        :email => user.email}
      
      expect(response).to redirect_to(users_user_url(user))
      expect(flash[:success]).to be_present
      expect(assigns(:user)).to be_activated
    end
    
    it "should not accept an invalid token" do
      get :edit, { :id => "invalid_token",
              :email => user.email}
       
       expect(response).to redirect_to(:root)
      expect(flash[:danger]).to be_present
    end
    
    it "should not accept an invalid mail" do
      get :edit, { :id => user.activation_token,
              :email => "not@valid.mail"}
       
       expect(response).to redirect_to(:root)
      expect(flash[:danger]).to be_present
    end
    
  end
  
  
end
