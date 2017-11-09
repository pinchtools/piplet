FactoryBot.define do

  factory :user do
    sequence(:username) { Faker::Lorem.characters(10) }
    sequence(:email) { |n| "example#{n}@domain.com" }
    password 'foobarfoobar'
    password_confirmation 'foobarfoobar'
    creation_ip_address '127.6.4.98'
    activated true
    activated_at Time.zone.now
    activation_ip_address '127.6.4.98'

    trait :is_admin do
      admin true
    end

    trait :is_unactivated do
      activated false
      activated_at nil
      activation_ip_address nil
    end

    trait :is_blocked do
      blocked true
      blocked_at Time.zone.now
    end

    trait :is_suspected do
      suspected true
      suspected_at Time.zone.now
    end

    trait :is_deactivated do
      deactivated true
      deactivated_at Time.zone.now
    end

    trait :is_to_be_deleted do
      deactivated true
      deactivated_at Time.zone.now
      to_be_deleted true
      to_be_deleted_at Time.zone.now

    end

    trait :with_blocked_filter do
      after(:create) do |user|
        user.filters << create(:user_filter_blocked_email)
      end
    end

    trait :with_trusted_filter do
      after(:create) do |user|
        user.filters << create(:user_filter_trusted_email)
      end
    end
  end


  factory :admin,  parent: :user do
    is_admin
  end

  factory :user_blocked, parent: :user do
    is_blocked
  end

  factory :user_blocked_by_filter, parent: :user  do
    with_blocked_filter
  end

  factory :user_trusted_by_filter, parent: :user  do
    with_trusted_filter
  end

  factory :user_suspected, parent: :user do
    is_suspected
  end

  factory :user_deactivated, parent: :user do
    is_deactivated
  end

  factory :user_to_be_deleted, parent: :user do
    is_to_be_deleted
  end

  factory :user_unactivated, parent: :user do
    is_unactivated
  end
end
