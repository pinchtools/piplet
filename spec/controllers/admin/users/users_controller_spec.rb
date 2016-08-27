require 'rails_helper'

RSpec.describe Admin::Users::UsersController, type: :controller do
  include Helpers
  
  describe "GET #index" do 
    it "redirect to login page if not authorized" do
      get :index
      
      should_redirect_to_login
    end
    
    it_behaves_like 'a restricted access to admin only' do 
      let(:request) { get :index }
    end
  end

  describe "GET #search" do
    
    it_behaves_like 'a restricted access to admin only' do 
      let(:request) { get :search, :search => '' }
    end
    
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
    let!(:admin) { FactoryGirl.create(:admin) }
    
    
    it_behaves_like 'a restricted access to admin only' do 
      let(:request) { delete :destroy, username: admin.username_lower }
    end
    
    it "should redirect when there is only one admin" do
      expect(User.admins.count).to eq(1)
      
      log_in_as(admin)
      
      delete :destroy, username: admin.username_lower
      
      expect(:response).to redirect_to(:admin_users_users)
      expect(flash[:danger]).to be_present
    end
    
  end
end
