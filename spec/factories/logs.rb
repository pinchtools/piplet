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
  
  factory :log_i18n, parent: :log do
      action 1
      level 1
      message "logs.messages.created"
      by_user
  end
  
  factory :log_i18n_with_vars, parent: :log do
    action 1
    level 1
    message "logs.messages.email_similar"
    message_vars { {"email":"example1@piplet.io", "blocked_email":"example2@piplet.io"} }
    by_user
  end
  
  
end
