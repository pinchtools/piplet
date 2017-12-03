shared_context 'valid access-token' do
  let(:options) { {user: user.id, exp: 1.day.after.to_i, iat: 5.minutes.ago.to_i} }
  let(:token) { JsonWebToken.encode(options) }

  before { request.headers['Authorization'] = token }
end

shared_context 'valid csrf-token' do
  let(:csrf_options) { {user: user.id } }
  let(:csrf_token) { JsonWebToken.encode(csrf_options) }
  before do
    request.headers['x-csrf-token'] = csrf_token
  end
end

shared_context 'concerned by filters returns true' do
  let(:filter_service) {instance_double('Users::ConcernedByFiltersService')}
  let(:concerned_by_filter) { true }
  before do
    allow(Users::ConcernedByFiltersService).to receive(:new).with(user).and_return(filter_service)
    allow(filter_service).to receive(:call).and_return(concerned_by_filter)
  end
end

shared_context 'valid site authentication' do | define_site: false |
  let(:site) {create(:site)} if define_site
  let(:api_key) { site.api_keys.first }
  before {
    request.headers['x-api-key'] = api_key.public_key
  }
end
