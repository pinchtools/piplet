shared_examples "authentication validation" do |method, url, request_options: {}, silent_expiration: false|
  before do
    request_options[:params] = {} if request_options[:params].blank?
  end

  context 'token is not passed' do
    before { send(method, url) }
    it { expect(response).to have_http_status(:unauthorized) }
  end

  context 'an invalid token is passed' do
    before do
      request.headers['Authorization'] = 'aaa'
      send(method, url, request_options)
    end
    it { expect(response).to have_http_status(:unauthorized) }
  end

  unless silent_expiration
    context 'an expired token is passed' do
      let(:user) {create(:user)}
      let(:options) { {user: user.id, exp: 1.day.ago.to_i, iat: 5.minutes.ago.to_i} }
      let(:token) { JsonWebToken.encode(options) }

      before do
        request.headers['Authorization'] = token
        send(method, url, request_options)
      end
      it {expect(response).to have_http_status(:unauthorized) }
    end
  end

  context 'token is valid but user does not exists' do
    let(:options) { {user: 111, exp: 1.day.after.to_i, iat: 5.minutes.ago.to_i} }
    let(:token) { JsonWebToken.encode(options) }

    before do
      request.headers['Authorization'] = token
      send(method, url, request_options)
    end
    it {expect(response).to have_http_status(:unprocessable_entity) }
  end

  shared_examples 'invalid user' do |user_type|
    let(:user) {create(user_type)}
    let(:options) { {user: user.id, exp: 1.day.after.to_i, iat: 5.minutes.ago.to_i} }
    let(:token) { JsonWebToken.encode(options) }

    before do
      request.headers['Authorization'] = token
      send(method, url, request_options)
    end
    it {expect(response).to have_http_status(:unprocessable_entity) }
  end

  context 'token is valid but concerned user is blocked' do
    include_examples 'invalid user', :user_blocked
  end

  context 'token is valid but concerned user is deactivated' do
    include_examples 'invalid user', :user_deactivated
  end

  context 'token is valid but concerned user is not activated yet' do
    include_examples 'invalid user', :user_unactivated
  end

  context 'an attribute is missing into the payload' do
    let(:user) {create(:user_blocked)}
    let(:options) { {user: user.id, exp: 1.day.after.to_i, iat: 5.minutes.ago.to_i} }

    ['user', 'exp', 'iat'].each do |attr|
      it 'returns an error' do
        request.headers['Authorization'] = JsonWebToken.encode(options.except(attr))
        send(method, url, request_options)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context  'a valid token is passed' do
    let(:user) {create(:user)}
    let(:options) { {user: user.id, exp: 1.day.after.to_i, iat: 5.minutes.ago.to_i} }
    let(:token) { JsonWebToken.encode(options) }

    before do
      request.headers['Authorization'] = token
      send(method, url, request_options)
    end
    it { expect(assigns(:current_user)).to eq(user) }
  end

  context 'web platform' do
    before do
      request_options[:params][:client_platform] = 'web'
    end

    describe 'no token are passed' do
      it 'returns a 422 error' do
        send(method, url, request_options)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'token is invalid' do
      let(:token) { 'badtoken' }
      before do
        request.cookies[:token] = token
      end

      it 'raises a decoding error' do
        send(method, url, request_options)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'token is valid' do
      let(:user) { create(:user) }
      let(:options) { {user: user.id, exp: 1.day.after.to_i, iat: 5.minutes.ago.to_i} }
      let(:token) { JsonWebToken.encode(options) }
      before do
        request.cookies['token'] = token
      end

      context 'csrf-token is not passed' do
        it 'returns an http error code' do
          send(method, url, request_options)
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'csrf-token is not a valid jwt' do
        before { request.headers['x-csrf-token'] = 'foo' }
        it 'returns an http error code' do
          send(method, url, request_options)
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'user contained in the csrf payload does not match with the access token one' do
        let(:user2) { create(:user) }
        let(:csrf_options) { {user: user2.id } }
        let(:csrf_token) { JsonWebToken.encode(csrf_options) }
        before do
          request.headers['x-csrf-token'] = csrf_token
          send(method, url, request_options)
        end
        it { expect(response).to have_http_status(:unauthorized) }
      end

      context 'csrf token is valid' do
        let(:csrf_options) { {user: user.id } }
        let(:csrf_token) { JsonWebToken.encode(csrf_options) }
        before do
          request.headers['x-csrf-token'] = csrf_token
          send(method, url, request_options)
        end

        it 'assigns the current user' do
          expect(assigns(:current_user)).to eq(user)
        end
      end
    end
  end
end

shared_examples 'object response contains' do |key, kind:|
  it "includes #{key} in the response body" do
    json = JSON.parse response.body

    expect(json['data']).to include(
                              'attributes' => hash_including(key => kind_of(kind))
                            )
  end
end

shared_examples 'object response does not contain' do |key|
  it "includes #{key} in the response body" do
    json = JSON.parse response.body

    expect(json['data']).not_to include(
                              'attributes' => hash_including(key)
                            )
  end
end
