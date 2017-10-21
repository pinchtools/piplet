
shared_context 'a request by username' do |path|
  let(:user) { create(:admin) }
  before {
    log_in_as(user)
  }

  it 'renders view when user exists' do
    get path, params: { username: user.username_lower }

    expect(response).to have_http_status(:success)
  end

  it 'redirects when usersame is invalid' do
    get path, params: { username: 'a' }

    expect(response).to redirect_to(:admin_users_users)
  end

end

shared_context 'a restricted access to admin only' do
  context 'admin' do
    let(:user) { create(:admin) }
    before {
      log_in_as(user)
    }

    it 'has access' do
      request

      expect(response).not_to redirect_to(:login)
    end
  end

  context 'regular' do
    let(:user) { create(:user) }
    before {
      log_in_as(user)
    }

    it 'has access' do
      request

      expect(response).to redirect_to(:login)
    end
  end
end
