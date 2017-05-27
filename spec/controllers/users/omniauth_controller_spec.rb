require 'rails_helper'

RSpec.describe Users::OmniauthController, type: :controller do

  before do
    request.env['omniauth.auth'] = OmniAuth::AuthHash.new(auth_hash)
    request.env['omniauth.params'] = auth_params
  end

  let(:auth_infos) {{ name: 'franz', nickname: 'grangousier', email: 'fgrangousier@gmail.com', image: 'img.jpg' }}
  let(:auth_hash) {{ provider:'google', uid: 'goo1', infos: auth_infos }}
  let(:auth_params) {{}}
  let(:auth_email?) {1}
  let(:auth_img?) {1}

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
        it 'renders template' do
          get :callback, params: {provider: provider}
          expect(response).to render_template(:callback)
        end
      end

      context 'via client' do
        let(:auth_params) {{ 'from' => 'client' }}

        it 'creates a cookie' do
          get :callback, params: {provider: provider}

          expect(cookies).to have_key(:at)
          expect(cookies).to have_key(:rt)
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
        allow(redis).to receive(:add).and_return(true)
      end

      it 'redirects to complete profile' do
        get :callback, params: {provider: provider}

        expect(response).to redirect_to auth_complete_profile_url(
                                          token: token,
                                          auth_email: auth_email?,
                                          auth_img: auth_img?
                                        )
      end

      context 'cannot save cache' do
        before do
          allow(redis).to receive(:add).and_return(false)
        end

        it 'redirects to root_url with a warning' do
          get :callback, params: {provider: provider}

          expect(response).to redirect_to root_url
          expect(flash[:warning]).to be_present
        end

      end
    end
  end

end