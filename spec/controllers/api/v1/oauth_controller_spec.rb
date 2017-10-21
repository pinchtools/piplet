require 'rails_helper'

RSpec.describe Api::V1::OauthController, type: :controller do

  describe '#index' do
    shared_examples 'no providers found' do
      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'return an empty array' do
        json = JSON.parse response.body
        expect(json['data']).to be_empty
      end
    end

    context 'settings are empty' do
      before do
        allow(Setting).to receive(:[]).with('global.auth').and_return(nil)
        get :index
      end
      include_examples 'no providers found'
    end

    context 'all providers are deactivate' do
      let(:providers) { { 'facebook': { enable: '0' } } }
      before do
        allow(Setting).to receive(:[]).with('global.auth').and_return(providers)
        get :index
      end
      include_examples 'no providers found'
    end

    context 'a provider is activate' do
      let(:active_provider) { 'facebook' }
      let(:providers) { { "#{active_provider}" => { enable: '1' } } }
      before do
        allow(Setting).to receive(:[]).with('global.auth').and_return(providers)
        get :index
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'return an empty array' do
        json = JSON.parse response.body
        expect(json['data']).to include(hash_including('id' => active_provider))
      end
    end
  end
end
