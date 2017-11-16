FactoryGirl.define do 
  factory :access do
    level 1
    starts_at Time.now
    ends_at Time.now + 10.minutes
    association :user, factory: :user

    trait :future do
      level 2
      starts_at Time.now + 10.minutes
      ends_at Time.now + 20.minutes
    end
  end
end