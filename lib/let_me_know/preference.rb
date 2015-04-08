module LetMeKnow
  class Preference < ::ActiveRecord::Base
    self.table_name = "notification_preferences"

    belongs_to :owner, polymorphic: true
    has_many :notifications, foreign_key: :notification_preference_id
    has_many :unsent_notifications, -> { where(sent_at: nil) }, class_name: '::LetMeKnow::Notification', foreign_key: :notification_preference_id

    validates_presence_of :owner
    validates_inclusion_of :send_notifications, in: [true, false]

    def self.schedule_options
      [:immediately, :daily, :weekly]
    end

    validates_inclusion_of :schedule, in: schedule_options + schedule_options.map(&:to_s), allow_nil: true
    before_validation :clear_schedule, unless: :send_notifications
    before_validation :symbolize_schedule
    validate :has_schedule, if: :send_notifications

    def schedule_options
      self.class.schedule_options
    end

    def immediate?
      schedule.to_sym == :immediately
    end

    private

    def clear_schedule
      self.schedule = nil
    end

    def symbolize_schedule
      self.schedule = schedule.to_sym unless schedule.nil?
    end

    def has_schedule
      errors.add(:schedule, "can't be blank when receiving notifications") unless schedule.present?
    end
  end
end
