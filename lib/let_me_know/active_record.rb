module LetMeKnow
  module ActiveRecord
    def notification_recipient
      has_one :notification_preference, class_name: '::LetMeKnow::Preference', dependent: :destroy, as: :owner
      after_create LetMeKnow::InitialPreferences.new
    end

    def notification_subject
      after_commit LetMeKnow::MakeNotifications.new
      has_many :notifications, class_name: '::LetMeKnow::Notification', dependent: :destroy, as: :subject
    end
  end
end
