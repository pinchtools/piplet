require 'rails_helper'

RSpec.describe Admin::Sites::SitesController, type: :controller do
  include Helpers

  describe "GET #index" do
    it_behaves_like 'a restricted access to admin only' do
      before {
        allow(Site).to receive(:first) { double( :uid => 'test' ) }
      }

      let(:request) { get :index, params: { username: 'a' } }
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

  describe "POST #create" do
    before {
      user = create(:admin)
      log_in_as(user)
    }

    context 'when succeed' do
      it 'should render view with flash message' do
        post :create, xhr: true, params: { site: {name: 'test' } }
        expect(flash[:success]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when failed' do
      it 'should render view without flash message' do
        post :create, xhr: true,  params: { site: {name: 't' } }
        expect(flash[:success]).to be_blank
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET #edit" do

    it_behaves_like 'a restricted access to admin only' do
      before {
        allow(Site).to receive(:first) { double( :uid => 'test' ) }
      }

      let(:request) { get :edit, params: { :site_uid => 'test' } }
    end

  end


  describe "PATCH #update" do
    before {
      user = create(:admin)
      log_in_as(user)
    }

    let(:site) { create(:site) }


    context 'when succeed' do
      it 'redirects to #edit' do
        patch :update, params: { site_uid: site.uid, site: { name: 'test' } }

        expect(response ).to redirect_to(edit_admin_site_path)
      end
    end

    context 'when failed' do
      it 'renders #edit template' do
        patch :update, params: { site_uid: site.uid, site: { name: nil } }

        expect(response).to have_http_status(:ok)
      end
    end
  end

end
