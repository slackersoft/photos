FactoryGirl.define do
  sequence :email do |n|
    "jimbob#{n}@example.com"
  end

  factory :user do
    email
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
