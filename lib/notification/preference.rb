class Notification::Preference < ActiveRecord::Base
  self.table_name = "notification_preferences"

  belongs_to :user

  validates_presence_of :user
  validates_presence_of :send_notifications

  def self.schedule_options
    [:immediately, :daily, :weekly]
  end
  validates_inclusion_of :schedule, in: schedule_options, allow_nil: true
  before_validation :clear_schedule, unless: :send_notifications
  validate :has_schedule, if: :send_notifications

  def schedule_options
    self.class.schedule_options
  end

  private

  def clear_schedule
    self.schedule = nil
  end

  def has_schedule
    errors.add(:schedule, "can't be blank when receiving notifications") unless schedule.present?
  end
end
