FactoryBot.define do
  factory :conversation do
    sequence(:identifier) { |n| "id#{n}" }
    site
  end
end
