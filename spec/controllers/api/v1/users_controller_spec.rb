require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe '#create' do
    let(:required_params) { { username: 'totolitoto', email: 'foobar@foobar.com', password: 'foobarfoobar', password_confirmation: 'foobarfoobar' } }
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

    it 'returns access tokens' do
      post :create, params: params

      json = JSON.parse response.body

      expect(json['data']).to include(
                                  'attributes'=> hash_including(
                                      'api-access-token'=> kind_of(String),
                                      'api-refresh-token'=> kind_of(String)
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
  end
end