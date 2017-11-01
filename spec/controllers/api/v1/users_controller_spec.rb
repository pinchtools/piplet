require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe '#create' do
    let(:client_platform) { 'stateless' }
    let(:required_params) {
      {
        username: 'totolitoto',
        email: 'foobar@foobar.com',
        password: 'foobarfoobar',
        password_confirmation: 'foobarfoobar',
        client_platform: client_platform
      }
    }
    let(:params) { required_params }
    let!(:http_request) { post :create, params: params }

    it 'returns a success code' do
      expect(response).to have_http_status(:created)
    end

    include_examples 'object response contains', 'username', kind: String
    include_examples 'object response contains', 'email', kind: String
    include_examples 'object response contains', 'api-access-token', kind: String

    describe 'when a required parameter is missing' do
      let(:http_request) { nil }

      it 'returns an error' do
        i = 0
        while i < required_params.count
          post :create, params: required_params.except( required_params.keys[i] )
          json = JSON.parse response.body

          expect(json).to have_key('errors')
          i += 1
        end
      end

      it 'returns an unprocessable error when a required param is missing' do
        i = 0
        while i < required_params.count
          post :create, params: required_params.except( required_params.keys[i] )

          expect(response).to have_http_status(:unprocessable_entity)
          i += 1
        end
      end
    end

    shared_examples 'returns an error' do
      it 'contains an error key' do
        post :create, params: params
        json = JSON.parse response.body
        expect(json).to have_key('errors')
      end
    end

    context 'username exists' do
      let(:http_request) { nil }
      let!(:user) { create(:user, username: params[:username]) }

      include_examples 'returns an error'
    end

    context 'email exists' do
      let(:http_request) { nil }
      let!(:user) { create(:user, email: params[:email]) }

      include_examples 'returns an error'
    end

    context 'concerned by filter' do
      let(:http_request) { nil }
      let(:email_provider) { params[:email].partition('@').last }
      let!(:filter) {create(:user_filter_blocked_email, email_provider: email_provider)}

      include_examples 'returns an error'
    end

    context 'web client perform' do
      let(:params) { required_params.merge(client_platform: 'web') }
      let(:http_request) {post :create, params: params}

      include_examples 'object response does not contain', 'api-access-token'

      it 'sets a token cookie' do
        expect(cookies).to have_key(:token)
      end

      include_examples 'object response contains', 'csrf-token', kind: String
    end
  end

  describe '#update' do
    let(:user) { create(:user) }
    include_context 'valid access-token'
    let!(:http_request) { put :update }

    it 'returns an ok status code' do
      expect(response).to have_http_status(:ok)
    end

    include_examples 'object response does not contain', 'api-access-token'
    include_examples 'object response does not contain', 'refresh-token'

    describe 'a new description is post' do
      let(:description) { 'update_test' }
      let!(:http_request) { put :update, params: {description: description} }

      it 'updates the user\'s description ' do
        expect(user.reload.description).to eq(description)
      end
    end
  end

  describe '#show' do
    include_examples 'authentication validation', :get, :show
  end
end
