require 'rails_helper'

RSpec.describe Users::NotificationsController, type: :controller do
  include Helpers
  
  describe "GET #index" do
    it "returns http success" do
      log_in_as( create(:user) )
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
