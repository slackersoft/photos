FactoryGirl.define do
  factory :tag do
    sequence(:name) { |n| "hiya#{FACTORY_BASE_NUMBER + n}" }
  end
end
