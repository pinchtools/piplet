require 'rails_helper'

RSpec.describe Users::UsersController, type: :controller do
  include Helpers
  include ActiveJob::TestHelper
  

  
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "POST #create" do
    it "fails when invalid information are send " do
      user_params = { :name => "", 
        :email => "",
        :password => "", 
        :password_confirmation => ""
      }
      
      count = User.count
      
      post(:create, params: { user: user_params })
      
      expect(User.count).to eq(count)
      expect(response).to have_http_status(:ok)

    end
    
    context "valid user" do
      
      let(:user_params) {
         build(:user).attributes.merge({
                  :password => 'foobarfoobar',
                  :password_confirmation => 'foobarfoobar',
                  :activated => false
                })
      }
      
      it "create a valid user" do
        ActionMailer::Base.deliveries.clear
        
        count = User.count
        
        expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(0)
  
        post :create, params: { :user => user_params }
        
        expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(1)
        
        expect(User.count).to eq(count + 1) # add a new User
        expect(response).to redirect_to(:root)
        expect(flash[:info]).to be_present
      end
      
    end
    
  end # END POST #create
  
  describe "GET #show" do
    it 'redirect to root when no username found' do
      username = 'testnotexists'
      
      expect(User.find_by_username_lower(username)).to be nil
      
      get :show, params: { :username => username }
      
      expect(response).to redirect_to(:root)
    end
    
    it 'show profile of existing user' do
      user = create(:user)
      
      get :show, params: { :username => user.username_lower }
      
      expect(response).to be_success
    end
  end
  
  describe "GET #edit" do
    it "need to be logged" do
      user = create(:user)
    
      get :edit
    
      should_redirect_to_login
    end

    it "should forward to edit when you are invited to logged-in before" do
      user = create(:user)
    
      get :edit
    
      expect(session[:forwarding_url]).to be_present
      
      should_redirect_to_login

      log_in_as user
      
      expect(response).to redirect_to (users_edit_path)
      expect(session[:forwarding_url]).to be_nil
    end
    
    
    context 'user is logged' do
      let (:user) { log_in_as( create(:user) ) }

    end
    
  end
  
  describe "PATCH #update" do 
    
    it "need to be logged" do
      user = create(:user)
      
      patch :update, params: { :user => user.attributes, :id => user.id }
    
      should_redirect_to_login
    end
    
        
    context 'when user is logged' do
      let(:user) { log_in_as( create(:user) ) }
        
      it "handle invalid validation" do
        user.email = nil
        
        patch :update, params: { :user => user.attributes, :id => user.id }
        
        expect(response).to have_http_status(:ok)
      end
      
      
      it 'update valid form' do
        new_password = 'foobarfoobar2'
        
        expect(user.password).not_to eq(new_password)
        
        user_params = user.attributes.merge({
          :password => new_password,
          :password_confirmation => new_password
        })
        
        patch :update, params: { :id => user.id, :user => user_params }
        expect(flash[:success]).to be_present
        expect(response).to redirect_to( users_edit_path )
      end
      
      
      it 'accepts empty password' do
        user.password = nil
        user.password_confirmation = nil
        
        patch :update, params: { :id => user.id, :user => user.attributes }
  
        expect(flash[:success]).to be_present
        expect(response).to redirect_to( users_edit_path )
      end
      
      
      it 'should not be able to set a user as admin' do
        
        expect(user.admin?).to be false
        
        patch :update,
              params: {
                  :id => user.id,
                  :user => user.attributes.merge({
                                                     :admin => true
                                                 })
              }
        
        expect(User.find(user.id)).not_to be_admin
        
      end
      
    end
  end
  
  describe "DELETE #destroy" do
    
    it "should redirect when there is only one admin" do
      User.admins.destroy_all
      
      admin = FactoryGirl.create(:admin)
      
      expect(User.admins.count).to eq(1)
      
      log_in_as(admin)
      
      delete :destroy, params: { username: admin.username_lower }
      
      expect(:response).to redirect_to(:root)
      expect(flash[:danger]).to be_present
    end
    
    it 'allows regular user to destroy himself' do
      log_in_as( create(:user), { remember_me: '1' })
      
      count = User.actives.count

      expect(cookies).to have_key(:remember_token)
      expect(cookies).to have_key(:user_id)
      
      delete :destroy
      
      expect(:response).to redirect_to(:root)

      expect(User.actives.count).to eq(count - 1)

      expect(cookies).to_not have_key(:remember_token)
      expect(cookies).to_not have_key(:user_id)
    end
      
  end
  
  describe "GET check_username" do
    it 'returns an error when username already exists' do
      user = create(:user)
      
      get :check_username, params: { :username => user.username }
      
      expect(response).to have_http_status(:bad_request)
    end
    
    it 'returns an empty error when username is ok' do
      username="randOm02"
      
      expect(User.find_by_username(username)).to be_nil
      
      get :check_username, params: { :username => username }
      
      expect(response).to have_http_status(:success)
    end
  end
  
end
