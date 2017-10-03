require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  include Helpers

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    context 'wrong email entered' do
      before do
        user.email = Faker::Internet.email
        log_in_as(user)
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'wrong password entered' do
      before do
        user.password = 'foobar'
        log_in_as(user)
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'user is not activated' do
      let(:user) { create(:user, activated: false) }
      before { log_in_as(user) }

      it { expect(response).to redirect_to(:root) }
      it { expect(flash[:warning]).to be_present }
    end

    context 'user is blocked' do
      let(:user) { create(:user_blocked) }
      before { log_in_as(user) }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(flash[:danger]).to be_present }
    end

    context 'user is concerned by a blocking filter' do
      let(:user) { create(:user) }
      let(:filter_service) {instance_double('Users::ConcernedByFiltersService')}
      let(:concerned_by_filter) { true }
      before do
        allow(Users::ConcernedByFiltersService).to receive(:new).with(user).and_return(filter_service)
        allow(filter_service).to receive(:call).and_return(concerned_by_filter)
        log_in_as(user)
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(flash[:danger]).to be_present }
    end

    context 'login/pass are valid' do
      let(:user) { create(:user) }
      before { log_in_as(user) }

      it { expect(session[:user_id]).to eq(user.id) }
      it { expect(response).to redirect_to( users_dashboard_index_path ) }
    end

    context 'user is an admin' do
      let(:user) { create(:admin) }
      before { log_in_as(user) }

      it { expect(session[:user_id]).to eq(user.id) }
      it { expect(response).to redirect_to( admin_dashboard_index_path ) }
    end

    describe 'remember me is checked' do
      let(:user) { create(:user) }
      before { log_in_as(user, { remember_me: '1' }) }

      it { expect(cookies).to have_key(:remember_token) }
      it { expect(cookies).to have_key(:user_id) }
    end

    describe 'remember me is cheked then unchecked' do
      let(:user) { create(:user) }
      before { log_in_as(user, { remember_me: '1' }) }

      it 'destroys remember_token cookie' do
        expect(response.cookies['remember_token']).not_to be_nil
        log_in_as(user)
        expect(response.cookies['remember_token']).to be_nil
      end

      it 'destroys user_id cookie' do
        expect(response.cookies['user_id']).not_to be_nil
        log_in_as(user)
        expect(response.cookies['user_id']).to be_nil
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    before do
      log_in_as(user, { remember_me: '1' })
      delete :destroy
    end

    it 'destroy cookies' do
      expect(response.cookies['remember_token']).to be_nil
      expect(response.cookies['user_id']).to be_nil
    end
  end
end
