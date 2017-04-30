require 'rails_helper'

RSpec.describe UserFilter, type: :model do
  
  subject{ build(:user_filter_blocked_email) }

  include_examples 'loggable'
      
  it { should have_and_belong_to_many(:users) }
    
  it { should validate_uniqueness_of(:email_provider) }
  it { should validate_uniqueness_of(:ip_address) }
    
  it { should validate_length_of(:email_provider).is_at_least(4).is_at_most(100) }
  it { should validate_length_of(:ip_address).is_at_least(5).is_at_most(50) }
  
  
  it "should accept email provider or ip address not both" do
    expect(subject.email_provider).to be_present
    
    subject.ip_address = Faker::Internet.ip_v4_address
    
    expect(subject).not_to be_valid
    
    subject.email_provider = nil
    subject.ip_address = nil
    
    expect(subject).not_to be_valid
    
    subject.email_provider = nil
    subject.ip_address = Faker::Internet.ip_v4_address
    
    expect(subject).to be_valid
  end
  
  it 'should have a valid email provider' do
    subject.ip_address = nil
    subject.email_provider = 'com'
    expect(subject).not_to be_valid
    
    expect(subject.errors).to have_key(:email_provider)
  end
  
  it 'should not accept an invalid ip address' do
    subject.email_provider = nil
    subject.ip_address = "xxxxx"
    
    expect(subject).not_to be_valid
    expect(subject.errors).to have_key(:ip_address)
    
  end
  
  it 'should accept a valid ip address' do
    subject.email_provider = nil

    #ip v4
    5.times.each do
      subject.ip_address = Faker::Internet.ip_v4_address
      
      expect(subject).to be_valid
    end
    
    #ip v6
    5.times.each do
      subject.ip_address = Faker::Internet.ip_v6_address
      
      expect(subject).to be_valid
    end
  end

  it 'calls service wich apply filter' do
    expect(UserFilter::ApplyWorker).to receive(:perform_async)
    subject.save
  end

  describe 'when related to users' do
    let!(:user) {create(:user, filters: [subject])}

    it 'removes relation with users when destroyed' do
      expect(subject.destroy).to be_truthy
      expect(user.reload.filters).to be_empty
    end
  end

  describe 'update' do
    context 'filter activate' do
      subject{ create(:user_filter_blocked_email) }

      it 'does not apply filter when deactivate' do
        expect(subject).not_to receive(:apply_to_existing_users)
        subject.update_attribute(:blocked, false)
      end
    end

    context 'filter deactivate' do
      subject{ create(:user_filter_blocked_email, blocked: false) }

      it 'applies filter when reactivated' do
        expect(subject).to receive(:apply_to_existing_users)
        subject.update_attribute(:blocked, true)
      end

    end

  end
end