module LetMeKnow
  class MakeNotifications
    def after_commit(subject)
      Preference.where(send_notifications: true).find_each do |pref|
        next if pref.owner == subject.user
        Notification.create(subject: subject, notification_preference: pref)
      end
    end
  end
end
