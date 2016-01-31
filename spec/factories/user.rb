FactoryGirl.define do

  factory :user do
    name Faker::Lorem.words(2).join(" ")
    email Faker::Internet.email
    password 'i_believe_i_can_fly'
    password_confirmation 'i_believe_i_can_fly'
  end
  
end