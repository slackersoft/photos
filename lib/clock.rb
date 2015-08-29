require 'clockwork'
require_relative '../config/boot'
require_relative '../config/environment'

module Clockwork
  every(10.minutes, 'check.mail') do
    MailChecker.check_for_mail
  end

  every(1.day, 'daily.notifications', at: '07:30') do
    LetMeKnow::PeriodicSender.send_notifications :daily
  end

  every(1.day, 'weekly.notifications', at: '06:00') do
    if Time.zone.now.sunday?
      LetMeKnow::PeriodicSender.send_notifications :weekly
    end
  end
end
