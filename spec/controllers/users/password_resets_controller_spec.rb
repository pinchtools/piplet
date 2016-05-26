require 'rails_helper'

RSpec.describe Users::PasswordResetsController, type: :controller do
  include Helpers
  include ActiveJob::TestHelper
  
  describe "POST #create" do
    let(:user) { create(:user) }
    
    it 'should send an email to a valid user' do

      expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(0)
      
      post :create, { password_reset: { :email => user.email } }
      
      expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(1)
      
      expect(response).to redirect_to(:root)
      expect(flash[:info]).to be_present
    end
    
    it 'should not accept invalid mail' do
      post :create, { password_reset: { email: "not@valid.mail"} }
      
      expect(response).to render_template(:new)
      expect(flash[:danger]).to be_present
    end
      
  end
  
  describe "PATCH #update" do
    let(:user) { create(:user) }
    before(:each) {
      user.create_reset_digest
    }
    
    
    it 'should update password of a valid user' do
      old_digest = user.password_digest
      
      
      patch :update,
        id: user.reset_token,
        email: user.email,
        user: {
          password: 'newfoobar',
          password_confirmation: 'newfoobar'
       }
      
      expect(response).to redirect_to( users_dashboard_index_path)
      expect(flash[:success]).to be_present
      expect(assigns(:user).password_digest).not_to eq(old_digest)
    end
    
    it 'should not update password if validity date is expired' do
      user.update_attribute(:reset_sent_at, DateTime.now - 3.hours)
      
      patch :update,
        id: user.reset_token,
        email: user.email,
        user: {
          password: 'newfoobar',
          password_confirmation: 'newfoobar'
       }
      
      expect(response).to redirect_to(new_users_password_reset_path)
      expect(flash[:danger]).to be_present
    end
    
    it 'should not accept an empty password' do
      patch :update,
        id: user.reset_token,
        email: user.email,
        user: {
          password: '',
          password_confirmation: ''
       }
      
      expect(response).to render_template(:edit)
      expect(assigns(:user).errors).to have_key(:password)
    end
    
    it 'should not accept an invalid password' do
      patch :update,
        id: user.reset_token,
        email: user.email,
        user: {
          password: 'no',
          password_confirmation: 'no'
       }

      expect(response).to render_template(:edit)
      expect(assigns(:user).errors).to have_key(:password)
    end
    
    it 'should not accept rest if password confirmation mismatched' do
      patch :update,
        id: user.reset_token,
        email: user.email,
        user: {
          password: 'newfoobar',
          password_confirmation: 'newfoobar1'
       }

      expect(response).to render_template(:edit)
      expect(assigns(:user).errors).to have_key(:password_confirmation)
    end
    
  end #PATCH #update
end