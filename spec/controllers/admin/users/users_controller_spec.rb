require 'rails_helper'

RSpec.describe Admin::Users::UsersController, type: :controller do
  include Helpers
  
  describe "GET #index" do 
    it "redirect to login page if not authorized" do
      get :index
      
      should_redirect_to_login
    end
  end

  describe "GET # search" do
    
    context "logged" do
      before {
        user = create(:admin)
        log_in_as(user)
      }
      
      it "warn when input is too short" do
        get :search, :search => 'a'
        
        expect(flash.now[:warning]).to be_present
      end
      
      it 'warn when input is too long' do
        get :search, :search => Faker::Lorem.characters(51) 
  
        expect(flash.now[:warning]).to be_present
      end
  
    end # logged ctx
  end # GET search

  describe "DELETE #destroy" do
    
    it 'prevent an admin from removing himself' do
      user = log_in_as( create(:admin) )
      count = User.count

      delete :destroy, id: user.id
      
      expect(:response).to redirect_to(:admin_users_users)
      expect(User.count).to eq(count)
      
    end
    
    it 'prevent an admin from removing another staff member' do
      
      user = log_in_as( create(:admin) )
      another_admin = create(:admin)
      
      count = User.count

      delete :destroy, id: another_admin.id
      
      expect(:response).to redirect_to(:admin_users_users)
      expect(User.count).to eq(count)
      
    end

    it 'allows an admin to remove a regular user' do
      lambda_user = create(:user)
      
      user = log_in_as( create(:admin) )
      count = User.count

      delete :destroy, id: lambda_user.id
      
      expect(:response).to redirect_to(:admin_users_users)
      expect(User.count).to eq(count - 1)
      
    end
    
    
    it 'redirect non-admin user' do
      lambda_user = log_in_as( create(:user) )
      
      delete :destroy, id: lambda_user.id
      
      should_redirect_to_login
    end
  end

  
    
end
