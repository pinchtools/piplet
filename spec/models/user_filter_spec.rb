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
  

  
  describe 'when related to users' do
    
    context 'blocking filter' do
      subject {build(:user_filter_blocked_email) }
      
      it 'should call block method on concerned users' do
        user = build(:user)
        user.email = "default@" + subject.email_provider
        
        expect(user.save).to be true
        expect(user).not_to be_blocked
                
        
        expect(subject).to receive(:delay).and_return(subject)

        expect(subject.save).to be true
        
        expect(user).to be_blocked
      end
      
    end
        
    
    it 'should remove relation with users when destroyed' do
      subject.save
      
      expect(subject.users).to be_empty
      
      subject.users << create(:user)
      
      user_id = subject.users.first.id
      
      #look if the filter is link to the user
      expect(User.find(user_id).filters.find_by(:id => subject.id)).to be_present
      
      expect(subject.destroy).not_to be(false)

      #look if the link between filter and user has been removed
      expect(User.find(user_id).filters.find_by(:id => subject.id)).to be_nil
    end
    
    describe '.. by the email provider' do
      subject {build(:user_filter_blocked_email) }
      
      let(:user) { build(:user) }
      
      it 'should concerned a user with same domain' do
        user.email = "example@" + subject.email_provider
        user.save
        
        expect(subject).to receive(:delay).and_return(subject)
        
        expect(subject.save).to be true
        
        expect(subject.users.find_by_id(user.id)).to be_present
      
      end
    end
    
    describe 'by the ip address' do
      subject {build(:user_filter_blocked_ip) }

      let(:user) { build(:user) }
    
      describe 'should concerned a user ' do
        it '... with same ip v4' do
          subject.ip_address = Faker::Internet.ip_v4_address
          
          user.creation_ip_address = subject.ip_address
          user.save
          
          expect(subject).to receive(:delay).and_return(subject)
          expect(subject.save).to be true
          expect(subject.users.find_by_id(user.id)).to be_present
        end
      
        it '... with same ip v6' do
          subject.ip_address = Faker::Internet.ip_v6_address
          
          user.creation_ip_address = subject.ip_address
          user.save
          
          expect(subject).to receive(:delay).and_return(subject)
          expect(subject.save).to be true
          expect(subject.users.find_by_id(user.id)).to be_present
      end
      
      it '.. included in wildcard ip' do
        subject.ip_address = "192.168.1.*"
        
        user.creation_ip_address = "192.168.1.5"
        user.save
        
        expect(subject).to receive(:delay).and_return(subject)
        expect(subject.save).to be true
        expect(subject.users.find_by_id(user.id)).to be_present
      end
      
        it '.. doesn\'t include too many ips with wildcard ip' do
          subject.ip_address = "192.168.1.*"
          
          user.creation_ip_address = "192.168.2.5"
          user.save
          
          expect(subject).to receive(:delay).and_return(subject)
          expect(subject.save).to be true
          expect(subject.users.find_by_id(user.id)).to be_nil
        end
      
        it '.. included in ip mask' do
          subject.ip_address = "192.168.1.0/24"
          
          user.creation_ip_address = "192.168.1.5"
          user.save
          
          expect(subject).to receive(:delay).and_return(subject)
          expect(subject.save).to be true
          expect(subject.users.find_by_id(user.id)).to be_present
        end

        it '... doesn\'t include too many ips with  ip mask' do
          subject.ip_address = "192.168.1.0/24"
          
          user.creation_ip_address = "192.168.2.5"
          user.save
          
          expect(subject).to receive(:delay).and_return(subject)
          expect(subject.save).to be true
          expect(subject.users.find_by_id(user.id)).to be_nil
        end
        
      end
    end
  end
  
end