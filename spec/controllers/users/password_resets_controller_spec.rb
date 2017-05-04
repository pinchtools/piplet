require 'rails_helper'

RSpec.describe Users::PasswordResetsController, type: :controller do
  include Helpers
  include ActiveJob::TestHelper
  
  describe "POST #create" do
    let(:user) { create(:user) }
    
    it 'should send an email to a valid user' do
      allow(user).to receive(:send_activation_email)

      expect {
        post :create, params: { password_reset: { :email => user.email } }
      }.to change{ Sidekiq::Extensions::DelayedMailer.jobs.size }.by(1)

      expect(response).to redirect_to(:root)
      expect(flash[:info]).to be_present
    end
    
    it 'should not accept invalid mail' do
      post :create, params: { password_reset: { email: "not@valid.mail"} }
      
      expect(response).to have_http_status(:ok)
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
            params: {
                id: user.reset_token,
                email: user.email,
                user: {
                    password: 'newfoobar',
                    password_confirmation: 'newfoobar'
                }
            }

      
      expect(response).to redirect_to( users_dashboard_index_path)
      expect(flash[:success]).to be_present
    end
    
    it 'should not update password if validity date is expired' do
      user.update_attribute(:reset_sent_at, DateTime.now - 3.hours)
      
      patch :update,
            params: {
                id: user.reset_token,
                email: user.email,
                user: {
                    password: 'newfoobar',
                    password_confirmation: 'newfoobar'
                }
            }

      
      expect(response).to redirect_to(new_users_password_reset_path)
      expect(flash[:danger]).to be_present
    end
    
    it 'should not accept an empty password' do
      patch :update,
            params: {
                id: user.reset_token,
                email: user.email,
                user: {
                    password: '',
                    password_confirmation: ''
                }
            }

      
      expect(response).to have_http_status(:ok)
    end
    
    it 'should not accept an invalid password' do
      patch :update,
            params: {
                id: user.reset_token,
                email: user.email,
                user: {
                    password: 'no',
                    password_confirmation: 'no'
                }
            }

      expect(response).to have_http_status(:ok)
    end
    
    it 'should not accept rest if password confirmation mismatched' do
      patch :update,
            params: {
                id: user.reset_token,
                email: user.email,
                user: {
                    password: 'newfoobar',
                    password_confirmation: 'newfoobar1'
                }
            }


      expect(response).to have_http_status(:ok)
    end
    
  end #PATCH #update
end