require 'rails_helper'

RSpec.describe Users::OmniauthController, type: :controller do

  before do
    request.env['omniauth.auth'] = OmniAuth::AuthHash.new(auth_hash)
    request.env['omniauth.params'] = auth_params
  end

  let(:auth_infos) {{ name: 'franz', nickname: 'grangousier', email: 'fgrangousier@gmail.com', image: 'img.jpg' }}
  let(:auth_hash) {{ provider:'google', uid: 'goo1', infos: auth_infos }}
  let(:auth_params) {{}}

  describe '#callback' do
    let(:provider) { 'google' }

    context 'user exists' do
      let(:user) { create(:user) }
      let!(:auth_account){ create(:auth_account, provider: auth_hash[:provider], uid: auth_hash[:uid], user: user) }

      context 'user is blocked' do
        let(:user) { create(:user, blocked: true) }

        it 'redirects to root with a warning' do
          get :callback, params: {provider: provider}

          expect(response).to redirect_to root_url
          expect(flash[:warning]).to be_present
        end
      end

      context 'via back office' do
        it 'creates a session' do
          get :callback, params: {provider: provider}
          expect(session[:user_id]).to eq(user.id)
        end
        it 'redirects to root_url' do
          get :callback, params: {provider: provider}
          expect(response).to redirect_to root_url
        end
      end

      context 'via client' do
        let(:auth_params) {{ 'from' => 'client' }}

        it 'creates a cookie' do
          get :callback, params: {provider: provider}

          expect(cookies).to have_key(:token)
        end

        it 'renders template' do
          get :callback, params: {provider: provider}
          expect(response).to render_template(:callback)
        end
      end
    end


    context 'account does not exists' do
      let(:token) {'1234'}
      let(:redis) {instance_double('RedisConnect')}

      before do
        allow(SecureRandom).to receive(:hex).and_return(token)
        allow(RedisConnect).to receive(:new).and_return(redis)
        allow(redis).to receive(:hadd).and_return(true)
      end

      it 'redirects to complete profile' do
        get :callback, params: {provider: provider}

        expect(response).to redirect_to auth_complete_profile_url(
                                          token: token,
                                          auth_email: 0,
                                          auth_img: 0
                                        )
      end

      context 'cannot save cache' do
        before do
          allow(redis).to receive(:hadd).and_return(false)
        end

        it 'redirects to root_url with an error' do
          get :callback, params: {provider: provider}

          expect(response).to redirect_to root_url
          expect(flash[:danger]).to be_present
        end
      end
    end
  end

  describe '#finalize' do
    let(:token) {'1234'}

    context 'auth_account not found' do
      it 'redirects to root_url with an error' do
        put :finalize, params: {token: token}

        expect(response).to redirect_to root_url
        expect(flash[:warning]).to be_present
      end
    end

    context 'with redis cache' do
      let!(:auth_account){ create(:auth_account) }
      let(:redis) {instance_double('RedisConnect')}
      let(:from) { nil }
      let(:cache_infos) {
        {
          'id' => auth_account.id,
          'from' => from
        }
      }
      before do
        allow(RedisConnect).to receive(:new).and_return(redis)
        allow(redis).to receive(:method_missing).with(:hgetall, token).and_return(cache_infos)
      end

      context 'and an invalid user' do
        it 'renders the complete_profile template' do
          post :finalize, params: {token: token, username: ''}
          expect(response).to render_template(:complete_profile)
        end
      end

      it 'creates a new user linked to the auth_account' do
        expect {
          post :finalize, params: {token: token, username: 'newauthuser'}
        }.to change{ User.count }.by (1)
        expect(auth_account.reload.user).to be_present
      end

      context 'authenticate from back office' do
        it 'creates a session' do
          post :finalize, params: {token: token, username: 'newauthuser'}
          expect(session).to have_key(:user_id)
        end

        it 'redirect to root_url with a success msg' do
          post :finalize, params: {token: token, username: 'newauthuser'}
          expect(response).to redirect_to root_url
          expect(flash[:success]).to be_present
        end
      end

      context 'authenticate from client' do
        let(:from) { 'client' }

        it 'creates a cookie' do
          post :finalize, params: {token: token, username: 'newauthuser'}
          expect(cookies).to have_key(:token)
        end

        it 'renders callback template' do
          post :finalize, params: {token: token, username: 'newauthuser'}
          expect(response).to render_template(:callback)
        end
      end
    end
  end

  describe '#failure' do
    it 'redirects to root_url with an error' do
      get :failure

      expect(response).to redirect_to root_url
      expect(flash[:danger]).to be_present
    end
  end
end
