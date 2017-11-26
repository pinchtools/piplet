FactoryBot.define do
  factory :trusted_domain do
    sequence(:domain) { |n| "sub#{n}.domain.com" }
    site
  end
end
