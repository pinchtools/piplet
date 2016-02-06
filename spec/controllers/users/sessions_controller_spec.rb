require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
  
  def log_in_as(user, options = {})
      session = { email: user.email, password: user.password }
      
      session[:remember_me] = options[:remember_me] if options[:remember_me].present?
      
      post :create, session: session
  end
  
  describe "POST #create" do
    
    it "fails with bad entries" do
      user = create(:user)
      
      user.email = Faker::Internet.email
      user.password = 'foobar'
      
      log_in_as(user)
        
      expect(response).to render_template(:new)
    end
    
    it "create a user session when suceed" do
      user = create(:user)
    
      log_in_as(user)
      
      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to( users_user_path(user) )
      
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
