FactoryBot.define do
  factory :page do
    sequence(:url) { |n| "http://example.com/#{n}" }
    sequence(:title) { |n| "My page #{n}" }
    locale 'en'
    conversation
  end
end
