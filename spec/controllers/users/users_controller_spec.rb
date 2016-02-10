require 'rails_helper'

RSpec.describe Users::UsersController, type: :controller do
  include Helpers
  
  describe "GET #index" do 
    it "redirect to login page if not authorized" do
      get :index
      
      should_redirect_to_login
    end
  end
  
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
      
      post(:create, user: user_params)
      
      expect(User.count).to eq(count)
      expect(response).to render_template(:new)

    end
    
    
    it "create a valid user" do
  
      user_params = build(:user).attributes.merge({
        :password => 'foobar',
        :password_confirmation => 'foobar'
      })
      
      count = User.count
      
      post :create, :user => user_params
      
      expect(User.count).to eq(count + 1) # one more user
      expect(session[:user_id]).to eq(assigns(:user).id) # create a session
      expect(response).to redirect_to( users_user_path(assigns(:user)) ) # redirect to user profile
    end
    
  end # END POST #create
  
  
  describe "GET #edit" do
    it "need to be logged" do
      user = create(:user)
    
      get :edit, :user => user.attributes, :id => user.id
    
      should_redirect_to_login
    end

    it "should forward to edit when you need to login before" do
      user = create(:user)
    
      get :edit, :id => user.id
    
      expect(session[:forwarding_url]).to be_present
      
      should_redirect_to_login

      log_in_as user
      
      expect(response).to redirect_to (edit_users_user_path(user.id))
      expect(session[:forwarding_url]).to be_nil
    end
        
    it 'should not be able to edit another user profile' do
      user = log_in_as create(:user)
      other_user = create(:user)
      
      get :edit, :user => other_user.attributes, :id => other_user.id
      
      expect(response).to redirect_to(root_url)
    end
    
    context 'user is logged' do
      let (:user) { log_in_as( create(:user) ) }


    end
    
  end
  
  describe "PATCH #update" do 
    
    it "need to be logged" do
      user = create(:user)
      
      patch :update, :user => user.attributes, :id => user.id
    
      should_redirect_to_login
    end
    
    
    it 'should not be able to edit another user profile' do
      user = log_in_as create(:user)
      other_user = create(:user)

      patch :update, :user => other_user.attributes, :id => other_user.id
      
      expect(response).to redirect_to(root_url)

    end
    
    context 'when user is logged' do
      let(:user) { log_in_as( create(:user) ) }
        
      it "handle invalid validation" do
        user.email = nil
        
        patch :update, :user => user.attributes, :id => user.id
        
        expect(assigns(:user)).not_to be_valid
        expect(response).to render_template(:edit)
      end
      
      
      it 'update valid form' do
        new_password = 'foobar2'
        
        expect(user.password).not_to eq(new_password)
        
        user_params = user.attributes.merge({
          :password => new_password,
          :password_confirmation => new_password
        })
        
        patch :update, :id => user.id, :user => user_params
        expect(flash[:success]).to be_present
        expect(response).to redirect_to( users_user_path(assigns(:user)))
        expect(user.password_digest).not_to eq(assigns(:user).password_digest)
        
      end
      
      
      it 'accepts empty password' do
        user.password = nil
        user.password_confirmation = nil
        
        patch :update, :id => user.id, :user => user.attributes
  
        expect(flash[:success]).to be_present
        expect(response).to redirect_to( users_user_path(assigns(:user)))
      end
      
      it 'should not be able to set a user as admin' do
        
        expect(user.admin?).to be false
        
        patch :update, :id => user.id, :user => user.attributes.merge({
          :admin => true
        })
        
        expect(User.find(user.id)).not_to be_admin
        
      end
      
    end
  end
  
  describe "DELETE #destroy" do
    
    it 'redirect non-admin user' do
      lambda_user = create(:user)
      
      user = log_in_as( create(:user) )
      count = User.count

      delete :destroy, id: lambda_user.id
      
      expect(:response).to redirect_to(:root)
      expect(User.count).to eq(count)
    end
    
    it 'effectively destroys an user when we\'re an admin' do
      lambda_user = create(:user)
      
      user = log_in_as( create(:admin) )
      count = User.count

      delete :destroy, id: lambda_user.id
      
      expect(:response).to redirect_to(:users_users)
      expect(User.count).to eq(count - 1)
      
    end
    
  end
  
  
end
