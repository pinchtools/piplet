FactoryGirl.define do
  factory :user_filter do
    email_provider "spamhost.com"
    ip_address nil
    blocked true
    trusted false
  end

end
