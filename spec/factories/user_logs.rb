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
#  target_user_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :user_log do
    action 1
    level 1
    message "user log test"
    ip_address Faker::Internet.ip_v4_address
    
    association :concerned_user, factory: :user
  end

end
