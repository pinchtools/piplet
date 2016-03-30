#require 'spec/factories/user_filters'

FactoryGirl.define do

  factory :user do
    sequence(:username) { Faker::Lorem.characters(10) }
    sequence(:email) { |n| "example#{n}@domain.com" }
    password 'foobar'
    password_confirmation 'foobar'
    creation_ip_address '127.6.4.98'
    activated true
    activated_at Time.zone.now
    activation_ip_address '127.6.4.98'
    
    trait :is_admin do
      admin true
    end
    
    trait :with_blocked_filter do
      after(:create) do |user|
        user.filters << create(:user_filter_blocked_email)
      end
    end
    
  end
  

  factory :admin,  parent: :user do
    is_admin
  end
  
  factory :user_blocked_by_filter, parent: :user  do
    with_blocked_filter
  end
  
end