# == Schema Information
#
# Table name: user_histories
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

RSpec.describe UserHistory, type: :model do
  subject { build(:user_history) }
  
  it { should validate_presence_of(:action) }
  it { should validate_presence_of(:level) }
  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:concerned_user_id) }
  
  it 'should not accept invalid action' do
    subject.action = -1
    
    expect(subject.valid?).to be false
    expect(subject.errors).to have_key(:action)
  end
    
  it 'should not accept invalid level' do
    subject.level = -1
    
    expect(subject.valid?).to be false
    expect(subject.errors).to have_key(:level)

  end
end
