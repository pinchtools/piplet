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
  
end
