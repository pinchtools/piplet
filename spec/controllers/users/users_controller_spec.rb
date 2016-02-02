require 'rails_helper'

RSpec.describe Users::UsersController, type: :controller do

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
  
end
