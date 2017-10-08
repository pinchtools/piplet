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

      it 'returns a created status code' do
        post :create, params: params
        expect(response).to have_http_status(:created)
      end

      it 'returns access tokens' do
        post :create, params: params
        json = JSON.parse response.body

        expect(json['data']).to include(
                                  'attributes'=> hash_including(
                                    'api-access-token'=> kind_of(String)
                                  )
                                )
      end

      context 'user is concerned by a blocking filter' do
        let(:filter_service) {instance_double('Users::ConcernedByFiltersService')}
        let(:concerned_by_filter) { true }
        before do
          allow(Users::ConcernedByFiltersService).to receive(:new).with(user).and_return(filter_service)
          allow(filter_service).to receive(:call).and_return(concerned_by_filter)
          post :create, params: params
        end

        include_examples 'creation failed'
      end

      context 'web client perform' do
        let(:params) { valid_params.merge(client_platform: 'web') }
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
  end

  describe '#update' do
    include_examples 'authentication validation', :put, :update, silent_expiration: true
    # refresh token related to another platform
    # refresh token blocked
    # refresh token does not exists
    # user concerned by a filter -> create a context here and re-use it everywhere
    # request ok http status
    # request ok access_token
    # request ok do not send refresh token
    # request ok platform web : access token is send as cookie

    describe 'access token not passed' do

    end
  end
end
