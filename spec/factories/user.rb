FactoryGirl.define do

  factory :user do
    sequence(:name) { Faker::Lorem.words(2).join(" ") }
    sequence(:email) { Faker::Internet.email }
      password 'foobar'
    password_confirmation 'foobar'
  end
  
end