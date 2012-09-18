module LetMeKnow
  class PeriodicSender
    def self.send_notifications(schedule)
      Notification.unsent.scheduled_as(schedule).find_each do |notification|
        notification.send_notification
      end
    end
  end
end
