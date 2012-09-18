module LetMeKnow
  class Mailer < ActionMailer::Base
    default from: 'photos@greggandjen.com'

    def notify(notification)
      @recipient = notification.recipient
      @subject = notification.subject
      @subject_type = @subject.class.name.sub(/^[^:]*::/, '').underscore.gsub(/_/, ' ')
      mail to: notification.recipient.email,
        subject: "New #{@subject_type} added"
    end
  end
end
