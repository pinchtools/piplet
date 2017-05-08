shared_context 'having a valid token' do
  let(:user) { create(:user) }
  let(:options) { {user: user.id, exp: 1.day.after.to_i, iat: 5.minutes.ago.to_i} }
  let(:token) { JsonWebToken.encode(options) }

  before { request.headers['Authorization'] = token }
end