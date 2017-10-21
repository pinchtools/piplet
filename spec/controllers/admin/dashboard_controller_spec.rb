require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
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

end
