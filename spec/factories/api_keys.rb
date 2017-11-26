FactoryBot.define do
  factory :api_key do
    sequence(:label) { |n| "key_#{n}" }
    sequence(:public_key) { |n| "public_key_#{n}" }
    sequence(:secret_key) { |n| "secret_key_#{n}" }
    site
  end
end
