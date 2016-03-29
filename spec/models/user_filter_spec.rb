require 'rails_helper'

RSpec.describe UserFilter, type: :model do
  
  subject{ build(:user_filter) }
  
  it { should have_and_belong_to_many(:users) }
    
  it { should validate_uniqueness_of(:email_provider) }
  it { should validate_uniqueness_of(:ip_address) }
    
  it { should validate_length_of(:email_provider).is_at_least(4).is_at_most(100) }
  it { should validate_length_of(:ip_address).is_at_least(5).is_at_most(50) }
    
    
  it "should accept email provider or ip address not both" do
      
   expect(subject.email_provider).to be_present
   
   subject.ip_address = Faker::Internet.ip_v4_address
   
   expect(subject.valid?).to be false
      
   subject.email_provider = nil
   subject.ip_address = nil
      
   expect(subject.valid?).to be false
      
   subject.email_provider = nil
   subject.ip_address = Faker::Internet.ip_v4_address
   
   subject.valid?
   
   expect(subject.valid?).to be true
    
  end
  
  it 'should be a trusting filter or blocking filter not both' do
    expect(subject.blocked).to be true
    
    subject.trusted = true
 
    expect(subject.valid?).to be false
        
    subject.blocked = false
    subject.trusted = false
        
    expect(subject.valid?).to be false
        
    subject.blocked = true
    subject.trusted = false
    
    expect(subject.valid?).to be true
  end

  it 'should have a valid email provider' do
    subject.email_provider = 'com'
    expect(subject.valid?).to be false
    
    expect(subject.errors).to have_key(:email_provider)
  end
  
end
