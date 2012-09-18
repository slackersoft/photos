module LetMeKnow
  class InitialPreferences
    def after_create(subject)
      subject.create_notification_preference! send_notifications: false
    end
  end
end
