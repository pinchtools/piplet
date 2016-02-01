FactoryGirl.define do

  factory :user do
    name Faker::Lorem.words(2).join(" ")
    email Faker::Internet.email
    password 'foobar'
    password_confirmation 'foobar'
  end
  
end