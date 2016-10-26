require 'rails_helper'

RSpec.describe Admin::Sites::SitesController, type: :controller do
  include Helpers

  describe "GET #index" do
    it_behaves_like 'a restricted access to admin only' do
      before {
        allow(Site).to receive(:first) { double( :uid => 'test' ) }
      }

      let(:request) { get :index, username: 'a' }
    end

    context "logged" do
      subject{ get :index }
      before {
        user = create(:admin)
        log_in_as(user)
      }

      it "redirects to admin_site_path(uid)" do
        site = double( :uid => 'test' )

        allow(Site).to receive(:first) { site }

        expect(subject).to redirect_to(admin_site_path(site.uid))
      end
    end


  end

end
