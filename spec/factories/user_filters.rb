FactoryGirl.define do
  factory :user_filter do
    
    trait :is_blocked do
      blocked true
      trusted false
    end
    
    trait :is_trusted do
          blocked true
          trusted false
        end
        
    
  end
  
  factory :user_filter_blocked_email, parent: :user_filter do
    is_blocked
    ip_address nil
    email_provider 'spamhost.com' 
  end

  factory :user_filter_blocked_ip, parent: :user_filter do
    is_blocked
    ip_address '192.168.1.3'
    email_provider nil
  end
  
  factory :user_filter_trusted_email, parent: :user_filter do
    is_trusted
    ip_address nil
    email_provider 'yahoo.com' 
  end

  factory :user_filter_trusted_ip, parent: :user_filter do
    is_trusted
    ip_address '192.168.1.3'
    email_provider nil
  end
    
end
