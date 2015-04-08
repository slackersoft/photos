module LetMeKnow
  class PeriodicSender
    def self.send_notifications(schedule)
      Preference.where(schedule: schedule).includes(:unsent_notifications).find_each do |pref|
        next if pref.unsent_notifications.empty?
        Mailer.notify_bulk(schedule, pref.unsent_notifications).deliver_now!
        Notification.transaction do
          pref.unsent_notifications.each(&:sent!)
        end
      end
    end
  end
end
