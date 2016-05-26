require 'rails_helper'


describe 'users/users/show.html.erb' do

  it 'displays profile without navbar when use is not in his own profile' do

    user = create(:user)
    current_user = create(:user)
    
    expect(user).not_to eq(current_user)
    render :template => 'users/users/show.html.erb', locals: { user: user, current_user: current_user }
    
    expect(rendered).to_not have_selector("#users-main-nav")
  end


  it 'displays a navbar when user goes to his profile' do
    user = create(:user)
    
    render :template => 'users/users/show.html.erb', locals: { user: user, current_user: user }
    
    expect(rendered).to have_selector("#users-main-nav")
  end


end
