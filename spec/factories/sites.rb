FactoryBot.define do
  factory :site do
    sequence(:name) { |n| "Test #{n}" }
  end
end
