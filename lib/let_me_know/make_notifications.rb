module LetMeKnow
  class MakeNotifications
    def after_commit(subject)
      Preference.where(send_notification: true).find_each do |pref|
        Notification.create(subject: subject, recipient: pref.owner)
      end
    end
  end
end
