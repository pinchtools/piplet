require 'rails_helper'

RSpec.describe Api::V1::TokensController, type: :controller do

  describe '#create' do
    let(:client_platform) { 'stateless' }
    let(:valid_params) { { email: user.email, password: user.password, client_platform: client_platform } }
    shared_examples 'creation failed' do
      it 'returns a 422 error' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'contains an errors attribute' do
        json = JSON.parse response.body
        expect(json).to have_key('errors')
      end
    end

    context 'email does not exists' do
      let(:params) { { email: 'not-existing-email@email.com' } }
      before do
        post :create, params: params
      end
      include_examples 'creation failed'
    end

    context 'password is incorrect' do
      let(:user) { create(:user) }
      let(:params) { { email: user.email, password: user.password + 'a' } }
      before do
        post :create, params: params
      end
      include_examples 'creation failed'
    end

    context 'user is blocked' do
      let(:user) { create(:user, blocked: true) }
      let(:params) { { email: user.email, password: user.password } }
      before do
        post :create, params: params
      end
      include_examples 'creation failed'
    end

    context 'user is not activated' do
      let(:user) { create(:user, activated: false) }
      let(:params) { valid_params }
      before do
        post :create, params: params
      end
      include_examples 'creation failed'
    end

    context 'user is valid' do
      let(:user) { create(:user) }
      let(:params) { valid_params }

      context do
        before { post :create, params: params }

        it {expect(response).to have_http_status(:created)}

        include_examples 'object response contains', 'api-access-token', kind: String
      end

      context 'user is concerned by a blocking filter' do
        include_context 'concerned by filters returns true'
        before {post :create, params: params}

        include_examples 'creation failed'
      end

      context 'web client perform' do
        let(:params) { valid_params.merge(client_platform: 'web') }
        before {post :create, params: params}

        include_examples 'object response does not contain', 'api-access-token'

        it 'sets a token cookie' do
          expect(cookies).to have_key(:token)
        end

        include_examples 'object response contains', 'csrf-token', kind: String
      end
    end
  end

  describe '#update' do
    include_examples 'authentication validation', :put, :update, silent_expiration: true

    context 'with an expired token' do
      let(:user) {create(:user)}
      let(:options) { {user: user.id, exp: 1.day.ago.to_i, iat: 5.minutes.ago.to_i} }
      let(:token) { JsonWebToken.encode(options) }
      before { request.headers['Authorization'] = token }

      it 'decodes the json and use it to find the user' do
        put :update
        expect(assigns(:current_user)).to eq(user)
      end

      describe 'refresh-token is not passed' do
        before { put :update }
        it { expect(response).to have_http_status(:unprocessable_entity) }
      end

      describe 'refresh token does not exists' do
        before { put :update, params: { refresh_token: 'foo' } }
        it { expect(response).to have_http_status(:unprocessable_entity) }
      end

      describe 'refresh token has been blocked' do
        let(:refresh_token) { create(:refresh_token, blocked_at: 1.day.ago, user: user) }
        before { put :update, params: { refresh_token: refresh_token.token, client_platform: refresh_token.platform }  }
        it { expect(response).to have_http_status(:unprocessable_entity) }
      end

      describe 'the refresh token exists but not for that platform' do
        let(:refresh_token) { create(:refresh_token, platform: Api::BaseHelper::WEB_CLIENT, user: user) }
        before { put :update, params: { refresh_token: refresh_token.token, client_platform: Api::BaseHelper::STATELESS_CLIENT } }
        it { expect(response).to have_http_status(:unprocessable_entity) }
      end

      context 'user is concerned by a blocking filter' do
        include_context 'concerned by filters returns true'

        let(:refresh_token) { create(:refresh_token, user: user) }
        before { put :update, params: { refresh_token: refresh_token.token, client_platform: refresh_token.platform } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
      end


      describe 'valid request' do
        let(:refresh_token) { create(:refresh_token, user: user) }
        before { put :update, params: { refresh_token: refresh_token.token, client_platform: refresh_token.platform } }

        it {expect(response).to have_http_status(:success)}

        include_examples 'object response contains', 'api-access-token', kind: String
        include_examples 'object response does not contain', 'refresh-token'

        context 'on a web platform' do
          include_context 'valid csrf-token'
          before do
            request.headers['Authorization'] = nil
            request.cookies['token'] = token

            put :update, params: { refresh_token: refresh_token.token, client_platform: client_platform }
          end
          let(:client_platform) { Api::BaseHelper::WEB_CLIENT }
          let(:refresh_token) { create(:refresh_token, user: user, platform: client_platform) }

          it {expect(response).to have_http_status(:success)}
        end
      end
    end
  end
end
