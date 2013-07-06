module LetMeKnow
  class Mailer < ActionMailer::Base
    default from: 'photos@greggandjen.com'

    def notify(notification)
      @recipient = notification.recipient
      @subject = notification.subject
      @subject_type = normalize_type_name @subject
      mail to: notification.recipient.email,
        subject: "New #{@subject_type} added"
    end

    def notify_bulk(schedule, notifications)
      @recipient = notifications.first.recipient
      @items = notifications.collect(&:subject)
      @usernames = @items.collect(&:user).uniq.collect(&:name)
      @subject_type = normalize_type_name @items.first
      mail to: @recipient.email,
        subject: "New #{@subject_type.pluralize} added in the last #{schedule == :daily ? 'day' : 'week'}"
    end

    private

    def normalize_type_name subject
      subject.class.name.sub(/^[^:]*::/, '').underscore.gsub(/_/, ' ')
    end
  end
end
