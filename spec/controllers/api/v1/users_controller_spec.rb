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

    it 'returns a success code' do
      post :create, params: params
      expect(response).to have_http_status(:created)
    end

    it 'returns info about user' do
      post :create, params: params

      json = JSON.parse response.body

      expect(json['data']).to include(
                                  'attributes'=> hash_including(
                                      'username'=> kind_of(String),
                                      'email'=> kind_of(String)
                                  )
                              )
    end

    it 'returns the access token' do
      post :create, params: params

      json = JSON.parse response.body

      expect(json['data']).to include(
                                  'attributes'=> hash_including(
                                      'api-access-token'=> kind_of(String)
                                  )
                              )
    end

    it 'returns an errors key when a required param is missing' do
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

    shared_examples 'returns an error' do
      it 'contains an error key' do
        post :create, params: params
        json = JSON.parse response.body
        expect(json).to have_key('errors')
      end
    end

    context 'username exists' do
      let!(:user) { create(:user, username: params[:username]) }

      include_examples 'returns an error'
    end

    context 'email exists' do
      let!(:user) { create(:user, email: params[:email]) }

      include_examples 'returns an error'
    end

    context 'concerned by filter' do
      let(:email_provider) { params[:email].partition('@').last }
      let!(:filter) {create(:user_filter_blocked_email, email_provider: email_provider)}

      include_examples 'returns an error'
    end

    context 'user is concerned by a blocking filter' do
      let(:filter_service) {instance_double('Users::ConcernedByFiltersService')}
      let(:concerned_by_filter) { true }
      before do
        allow(Users::ConcernedByFiltersService).to receive(:new).and_return(filter_service)
        allow(filter_service).to receive(:call).and_return(concerned_by_filter)
      end

      include_examples 'returns an error'
    end

    context 'web client perform' do
      let(:params) { required_params.merge(client_platform: 'web') }
      before {post :create, params: params}

      it 'does not include the access token in the response' do
        json = JSON.parse response.body

        expect(json['data']).not_to include(
                                  'attributes'=> hash_including(
                                    'api-access-token'=> kind_of(String)
                                  )
                                )
      end

      it 'sets a token cookie' do
        expect(cookies).to have_key(:token)
      end

      it 'includes a csrf-token' do
        json = JSON.parse response.body

        expect(json['data']).to include(
                                  'attributes'=> hash_including(
                                    'csrf-token'=> kind_of(String)
                                  )
                                )
      end
    end
  end

  describe '#update' do
    include_context 'having a valid token'

    it 'returns an ok status code' do
      put :update
      expect(response).to have_http_status(:ok)
    end

    it 'does not return access_token' do
      post :update
      json = JSON.parse response.body
      expect(json['data']['attributes']).not_to have_key('api-access-token')
    end

    it 'does not return refresh_token' do
      post :update
      json = JSON.parse response.body
      expect(json['data']['attributes']).not_to have_key('api-access-token')
    end

    it 'updates the user' do
      description = 'update_test'
      post :update, params: {description: description}
      expect(user.reload.description).to eq(description)
    end
  end

  describe '#show' do
    include_examples 'authentication validation', :get, :show
  end
end
