FactoryGirl.define do
  sequence :original_message_id do |n|
    "#{n}@mohawks.us"
  end

  factory :photo do
    image File.new(Rails.root.join('spec', 'fixtures', 'files', 'mohawk.jpeg'))
    name 'Mohawk'
    original_message_id
  end
end
