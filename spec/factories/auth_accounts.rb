FactoryGirl.define do
  factory :auth_account do
    provider 'google'
    sequence(:uid) { |n| "XB-AS-2#{n}" }
    sequence(:name) { Faker::Lorem.characters(10) }
    sequence(:nickname) { Faker::Lorem.characters(10) }
    image_url nil
    email nil
    user nil
  end
end
