require 'rails_helper'

RSpec.describe Log, type: :model do
  subject { build(:user_log) }
  
  it { should validate_presence_of(:action) }
  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:loggable) }
  
  
   it 'should  be saved when valid' do
    expect(subject).to be_valid
   end
  
  
  it 'should not accept invalid action' do
    subject.action = -1
    
    expect(subject).not_to be_valid
    expect(subject.errors).to have_key(:action)
  end
  
  
  it 'should not set a level when action is invalid' do
    subject.action = -1
    
    expect(subject.valid?).to be false
    expect(subject.errors).to have_key(:level)
  end

  
  it 'should set correct level depending on action' do
    #normal
    subject.action = Log.normal_actions.values.first
    
    expect(subject.valid?).to be true
    
    expect(subject.level).to eq(Log.levels[:normal])
    
    #important
    subject.action = Log.important_actions.values.first
    
    expect(subject.valid?).to be true
    
    expect(subject.level).to eq(Log.levels[:important])
    
    #sensitive
    subject.action = Log.sensitive_actions.values.first
    
    expect(subject.valid?).to be true
    
    expect(subject.level).to eq(Log.levels[:sensitive])
  end
  
  
  it 'should only accept staff member as action user on sensitive log' do
    
    # try saving sensitive log with lambda user
    user = create(:user)
    
    subject.action = Log.sensitive_actions.values.first
    subject.action_user = user
    
    expect(subject.valid?).to be false
    expect(subject.errors).to have_key(:action_user)
    
    # and now with an admin
    admin = create(:admin)
    subject.action_user = admin
    
    expect(subject.valid?).to be true
  end
end
