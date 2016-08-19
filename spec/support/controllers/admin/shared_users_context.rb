
shared_context 'a request by username' do |path|
  let(:user) { create(:admin) }
  before {
    log_in_as(user)
  }
    
  it 'renders view when user exists' do
    get path, username: user.username_lower
    
    expect(response).to have_http_status(:success)
  end
  
  it 'redirects when usersame is invalid' do
    get path, username: 'a'
    
    expect(response).to redirect_to(:admin_users_users)
  end

end