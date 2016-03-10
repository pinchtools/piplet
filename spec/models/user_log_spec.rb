# == Schema Information
#
# Table name: user_logs
#
#  id             :integer          not null, primary key
#  action         :integer
#  level          :integer
#  message        :text
#  data           :text
#  ip_address     :string
#  action_user_id :integer
#  concerned_user_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe UserLog, type: :model do
  subject { build(:user_log) }
  
  it { should validate_presence_of(:action) }
  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:concerned_user_id) }
  
  
   it 'should  be saved when valid' do
    expect(subject.save).to be true
   end
  
  
  it 'should not accept invalid action' do
    subject.action = -1
    
    expect(subject.valid?).to be false
    expect(subject.errors).to have_key(:action)
  end
  
  
  it 'should not set a level when action is invalid' do
    subject.action = -1
    
    expect(subject.valid?).to be false
    expect(subject.errors).to have_key(:level)
  end

  
  it 'should set correct level depending on action' do
    #normal
    subject.action = UserLog.normal_actions.values.first
    
    expect(subject.valid?).to be true
    
    expect(subject.level).to eq(UserLog.levels[:normal])
    
    #important
    subject.action = UserLog.important_actions.values.first
    
    expect(subject.valid?).to be true
    
    expect(subject.level).to eq(UserLog.levels[:important])
    
    #sensitive
    subject.action = UserLog.sensitive_actions.values.first
    
    expect(subject.valid?).to be true
    
    expect(subject.level).to eq(UserLog.levels[:sensitive])
  end
  
  
  it 'should only accept staff member as action user on sensitive log' do
    
    # try saving sensitive log with lambda user
    user = create(:user)
    
    subject.action = UserLog.sensitive_actions.values.first
    subject.action_user = user
    
    expect(subject.valid?).to be false
    expect(subject.errors).to have_key(:action_user)
    
    # and now with an admin
    admin = create(:admin)
    subject.action_user = admin
    
    expect(subject.valid?).to be true
  end
  
end
