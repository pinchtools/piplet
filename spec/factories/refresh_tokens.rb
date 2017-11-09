FactoryBot.define do
  factory :refresh_token do
    sequence(:token) { |n| "faketoken#{n}" }
    platform "stateless"
    user nil
    blocked_at nil
    blocked_reason nil
  end
end
