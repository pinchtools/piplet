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
  end
  

  factory :admin, class: User do
    sequence(:username) { Faker::Lorem.characters(10) }
    sequence(:email) { |n| "example#{n}@domain.com" }
    password 'foobar'
    password_confirmation 'foobar'
    creation_ip_address '127.6.4.98'
    admin      true
    activated true
    activated_at Time.zone.now
    activation_ip_address '127.6.4.98'
  end
  
end