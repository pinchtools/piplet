require 'rails_helper'

RSpec.describe Notification, type: :model do

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:kind) }
  it { should validate_presence_of(:user_id) }
    
  it { should belong_to(:user) } 
  
    
  context "Send one to an user" do
    let (:user) { create(:user) }
    
    before {
      expect(Notification).to receive(:delay).and_return(Notification)
    }
    
    it 'create a notification' do
      
      notif = Notification.send_to(user) do |notif|
        notif.title = 'test'
        notif.kind = Notification.kinds[:unknown]
      end
      
      expect(notif).to be_valid
    end
    
    it 'does not support invalid kind' do
      invalid_kind = 199
        
      notif = Notification.send_to(user) do |notif|
        notif.title = 'test'
        expect { notif.kind = invalid_kind }.to raise_error(ArgumentError)
      end

      expect(notif.errors).to have_key(:kind)
    end
      
  end # context
end