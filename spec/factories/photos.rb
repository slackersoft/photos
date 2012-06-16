FactoryGirl.define do
  factory :photo do
    image File.new(Rails.root.join('spec', 'fixtures', 'files', 'mohawk.jpeg'))
    name 'Mohawk'
    description "Two feet tall"
    sequence(:original_message_id) { |n| "#{FACTORY_BASE_NUMBER + n}@mohawks.us" }
  end
end
