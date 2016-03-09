FactoryGirl.define do

  factory :user do
    sequence(:username) { Faker::Lorem.characters(10) }
    sequence(:email) { |n| "example#{n}@domain.com" }
    password 'foobar'
    password_confirmation 'foobar'
    activated true
    activated_at Time.zone.now
  end
  

  factory :admin, class: User do
    sequence(:username) { Faker::Lorem.characters(10) }
    sequence(:email) { |n| "example#{n}@domain.com" }
    password 'foobar'
    password_confirmation 'foobar'
    admin      true
    activated true
    activated_at Time.zone.now
  end
  
end