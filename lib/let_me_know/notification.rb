module LetMeKnow
  class Notification < ::ActiveRecord::Base
    belongs_to :subject, polymorphic: true
    belongs_to :notification_preference, class_name: '::LetMeKnow::Preference'

    after_create :send_notification, if: :immediate?

    validates_presence_of :notification_preference

    def self.unsent
      where(sent_at: nil)
    end

    def self.daily
      scheduled_as(:daily)
    end

    def self.weekly
      scheduled_as(:weekly)
    end

    def self.scheduled_as(schedule)
      joins(:notification_preference).readonly(false).where('notification_preferences.schedule' => schedule)
    end

    def sent?
      sent_at.present?
    end

    def send_notification
      return if sent?
      Mailer.notify(self).deliver!
      sent!
    end

    def sent!
      update_attribute :sent_at, Time.now
    end

    def recipient
      notification_preference.owner
    end

    private

    def immediate?
      notification_preference.immediate?
    end
  end
end
