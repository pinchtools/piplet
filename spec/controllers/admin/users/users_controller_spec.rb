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
    before {
      User.admins.destroy_all
    }
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
  
  describe "POST #revert_removal" do
    let!(:admin) { FactoryGirl.create(:admin) }
    let!(:user) { create(:user_deactivated) }
      
    it_behaves_like 'a restricted access to admin only' do 
      let(:request) { post :revert_removal, username: admin.username_lower }
    end
    
    it 'should redirect and warn user not deactivated' do
      log_in_as(admin)
      
      expect(admin).not_to be_deactivated
      
      post :revert_removal, username: admin.username_lower
      
      expect(:response).to redirect_to(:edit_admin_users_user)
      expect(flash[:warning]).to be_present
    end
        
    
    context "deactivated" do
      let!(:user) { create(:user_deactivated) }
        
      it 'should call user revert_removal method' do
        log_in_as(admin)
        
        expect_any_instance_of(User).to receive(:revert_removal)
    
        post :revert_removal, username: user.username_lower
      end
      
      it 'should succeed' do
        log_in_as(admin)
            
        post :revert_removal, username: user.username_lower
        
        expect(:response).to redirect_to(:edit_admin_users_user)
        expect(flash[:success]).to be_present
      end
    end
    
    
    context "to_be_deleted" do
      let!(:user) { create(:user_to_be_deleted) }
        
      it 'should call user revert_removal method' do
        log_in_as(admin)
        
        expect_any_instance_of(User).to receive(:revert_removal)
    
        post :revert_removal, username: user.username_lower
      end
      
      it 'should succeed' do
        log_in_as(admin)
            
        post :revert_removal, username: user.username_lower
        
        expect(:response).to redirect_to(:edit_admin_users_user)
        expect(flash[:success]).to be_present
      end
    end
    
  end
end
