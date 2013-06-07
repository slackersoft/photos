FactoryGirl.define do
  factory :notification_preference, class: '::LetMeKnow::Preference' do
    send_notifications true
    schedule :daily
    owner factory: :user
  end
end
