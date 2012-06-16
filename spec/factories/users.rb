FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "jimbob#{FACTORY_BASE_NUMBER + n}@example.com" }
    authorized false
    admin false
  end

  factory :authorized, :parent => :user do
    authorized true
  end

  factory :admin, :parent => :authorized do
    admin true
  end
end
