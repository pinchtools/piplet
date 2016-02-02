require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
  
  
  describe "POST #create" do
    
    it "fails with bad entries" do
      post :create, session: { email: Faker::Internet.email, password: "foobar" }
        
      expect(response).to render_template(:new)
    end
    
    it "create a user session when suceed" do
      user = create(:user)
    
      post :create, session: { email: user.email, password: user.password }
      
      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to( users_user_path(user) )
      
    end
    
  end
  
  describe "DELETE #destroy" do
    
    it 'destroy cookies' do
      user = create(:user)
    
      post :create, session: { email: user.email, password: user.password }
      
      expect(cookies).to have_key(:remember_token)
      expect(cookies).to have_key(:user_id)
      
      delete :destroy
      
      expect(cookies).to_not have_key(:remember_token)
      expect(cookies).to_not have_key(:user_id)
    end
  end
  
  

end
