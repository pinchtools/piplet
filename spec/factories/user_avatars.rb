FactoryGirl.define do
  factory :user_avatar do
    kind 0
    user
  end
  
  factory :user_avatar_default, parent: :user_avatar do
    
  end

  factory :user_avatar_upload, parent: :user_avatar do
    kind 1
  end

  
  factory :user_avatar_gravatar, parent: :user_avatar do
    kind 2
  end


end
