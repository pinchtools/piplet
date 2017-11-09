require 'rails_helper'

RSpec.describe Admin::Users::UsersController, type: :controller do
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

  describe "GET #search" do
    before {
      User.admins.delete_all
    }
    let!(:admin) { FactoryBot.create(:admin) }

    it_behaves_like 'a restricted access to admin only' do
      let(:request) { get :search, params: { :search => '' } }
    end

    context "logged"  do

      it "warn when input is too short" do
        log_in_as(admin)

        get :search, params: { :search => 'a' }

        expect(flash.now[:warning]).to be_present
      end

      it 'warn when input is too long' do
        log_in_as(admin)

        get :search, params: { :search => Faker::Lorem.characters(51) }

        expect(flash.now[:warning]).to be_present
      end

    end # logged ctx
  end # GET search


  describe "DELETE #destroy" do
    before {
      User.admins.delete_all
    }
    let!(:admin) { FactoryBot.create(:admin) }

    it_behaves_like 'a restricted access to admin only' do
      let(:request) { delete :destroy, params: { username: admin.username_lower } }
    end

    it "should redirect when there is only one admin" do
      expect(User.admins.count).to eq(1)

      log_in_as(admin)

      delete :destroy, params: { username: admin.username_lower }

      expect(:response).to redirect_to(:admin_users_users)
      expect(flash[:danger]).to be_present
    end

  end


  describe "POST #block" do
    let!(:admin) { create(:admin) }
    let!(:user) { create(:user) }

    it_behaves_like 'a restricted access to admin only' do
      let(:request) { post :block, params: { username: admin.username_lower } }
    end

    it "should display a success message" do
      log_in_as(admin)

      post :block, params: { username: user.username_lower }


      expect(response).to redirect_to(:edit_admin_users_user)
      expect(flash[:success]).to be_present
    end

    it "should accept a note about this action" do
      log_in_as(admin)

      expect(user.blocked_note).to be_nil

      note = 'test note'

      post :block, params: { username: user.username_lower, user: { blocked_note: note } }

      expect(User.find(user.id).blocked_note).to eq(note)
    end

    it "shoud not be able to block another admin" do
      another_admin = create(:admin)

      log_in_as(admin)

      post :block, params: { username: another_admin.username_lower }

      expect(response).to redirect_to(:edit_admin_users_user)
      expect(flash[:danger]).to be_present
    end
  end

  describe "POST #revert_block" do
    let!(:admin) { create(:admin) }
    let!(:user) { create(:user) }

    it_behaves_like 'a restricted access to admin only' do
      let(:request) { post :revert_block, params: { username: admin.username_lower } }
    end

    it "should display a success message" do
      log_in_as(admin)

      post :revert_block, params: { username: user.username_lower }

      expect(response).to redirect_to(:edit_admin_users_user)
      expect(flash[:success]).to be_present
    end

    it "shoud not be able to block another admin" do
      another_admin = create(:admin)

      log_in_as(admin)

      post :block, params: { username: another_admin.username_lower }

      expect(response).to redirect_to(:edit_admin_users_user)
      expect(flash[:danger]).to be_present
    end
  end

  describe "POST #suspect" do
    let!(:admin) { create(:admin) }
    let!(:user) { create(:user) }

    it_behaves_like 'a restricted access to admin only' do
      let(:request) { post :suspect, params: { username: admin.username_lower } }
    end

    it "should display a success message" do
      log_in_as(admin)

      post :suspect, params: { username: user.username_lower }

      expect(response).to redirect_to(:edit_admin_users_user)
      expect(flash[:success]).to be_present
    end

    it "should accept a note about this action" do
      log_in_as(admin)

      expect(user.suspected_note).to be_nil

      note = 'test note'

      post :suspect, params: { username: user.username_lower, user: { suspected_note: note } }

      expect(User.find(user.id).suspected_note).to eq(note)
    end

    it "shoud not be able to suspect another admin" do
      another_admin = create(:admin)

      log_in_as(admin)

      post :suspect, params: { username: another_admin.username_lower }

      expect(response).to redirect_to(:edit_admin_users_user)
      expect(flash[:danger]).to be_present
    end
  end

  describe "POST #revert_suspect" do
    let!(:admin) { create(:admin) }
    let!(:user) { create(:user) }

    it_behaves_like 'a restricted access to admin only' do
      let(:request) { post :revert_suspect, params: { username: admin.username_lower } }
    end

    it "should display a success message" do
      log_in_as(admin)

      post :revert_suspect, params: { username: user.username_lower }

      expect(response).to redirect_to(:edit_admin_users_user)
      expect(flash[:success]).to be_present
    end

    it "shoud not be able to block another admin" do
      another_admin = create(:admin)

      log_in_as(admin)

      post :revert_suspect, params: { username: another_admin.username_lower }

      expect(response).to redirect_to(:edit_admin_users_user)
      expect(flash[:danger]).to be_present
    end
  end

  describe "POST #revert_removal" do
    let!(:admin) { FactoryBot.create(:admin) }
    let!(:user) { create(:user_deactivated) }

    it_behaves_like 'a restricted access to admin only' do
      let(:request) { post :revert_removal, params: { username: admin.username_lower } }
    end

    it 'should redirect and warn user not deactivated' do
      log_in_as(admin)

      expect(admin).not_to be_deactivated

      post :revert_removal, params: { username: admin.username_lower }

      expect(:response).to redirect_to(:edit_admin_users_user)
      expect(flash[:warning]).to be_present
    end


    context "deactivated" do
      let!(:user) { create(:user_deactivated) }

      it 'should call user revert_removal method' do
        log_in_as(admin)

        expect_any_instance_of(User).to receive(:revert_removal)

        post :revert_removal, params: { username: user.username_lower }
      end

      it 'should succeed' do
        log_in_as(admin)

        post :revert_removal, params: { username: user.username_lower }

        expect(:response).to redirect_to(:edit_admin_users_user)
        expect(flash[:success]).to be_present
      end
    end

    context "to_be_deleted" do
      let!(:user) { create(:user_to_be_deleted) }

      it 'should call user revert_removal method' do
        log_in_as(admin)

        expect_any_instance_of(User).to receive(:revert_removal)

        post :revert_removal, params: { username: user.username_lower }
      end

      it 'should succeed' do
        log_in_as(admin)

        post :revert_removal, params: { username: user.username_lower }

        expect(:response).to redirect_to(:edit_admin_users_user)
        expect(flash[:success]).to be_present
      end
    end

  end
end
