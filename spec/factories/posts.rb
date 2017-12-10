FactoryBot.define do
  factory :post do
    message Faker::Lorem.sentence
    user
    conversation
  end
end
