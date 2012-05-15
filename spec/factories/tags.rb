FactoryGirl.define do
  sequence :name do |n|
    "hiya#{n}"
  end

  factory :tag do
    name
  end
end
