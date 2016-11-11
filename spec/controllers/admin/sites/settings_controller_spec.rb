require 'rails_helper'

RSpec.describe Admin::Sites::SettingsController, type: :controller do
  include Helpers

  describe "GET #edit" do

    it_behaves_like 'a restricted access to admin only' do
      before {
        allow(Site).to receive(:first) { double( :uid => 'test' ) }
      }

      let(:request) { get :edit, :site_uid => 'test' }
    end

  end


  describe "PATCH #update" do
    before {
      user = create(:admin)
      log_in_as(user)
    }

    let(:site) { create(:site) }


    context 'when successed' do
      it 'redirects to #edit' do
        patch :update, :site_uid => site.uid, site: { name: 'test' }

        expect(response ).to redirect_to(admin_site_settings_edit_path)
      end
    end

    context 'when failed' do
      it 'renders #edit template' do
        patch :update, :site_uid => site.uid, site: { name: nil }

        expect(assigns(:site).errors).not_to be_empty
        expect(response).to render_template(:edit)
      end
    end
  end

end
