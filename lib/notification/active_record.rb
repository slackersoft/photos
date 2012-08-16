module Notification::ActiveRecord
  def notification_recipient
    has_one :notification_preference, class_name: '::Notification::Preference', dependent: :destroy
  end
end
