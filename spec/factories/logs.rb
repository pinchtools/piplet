FactoryGirl.define do
  factory :log do
    action 1
    level 1
    message "log test"
    ip_address Faker::Internet.ip_v4_address

    trait :by_user do
      association :loggable, factory: :user
    end
    
  end

  factory :user_log, parent: :log do
    by_user
  end
  
end
