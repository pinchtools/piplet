require 'rails_helper'

RSpec.describe Api::V1::TokensController, type: :controller do

  describe '#create' do

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
      let(:user) { create(:user) }
      let(:params) { { email: user.email, password: user.password } }
      before do
        post :create, params: params
      end

      it 'returns a created status code' do
        expect(response).to have_http_status(:created)
      end

      it 'returns access tokens' do
        json = JSON.parse response.body

        expect(json['data']).to include(
                                  'attributes'=> hash_including(
                                    'api-access-token'=> kind_of(String),
                                    'api-refresh-token'=> kind_of(String)
                                  )
                                )
      end
    end
  end
end
