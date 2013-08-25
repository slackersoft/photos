namespace :let_me_know do
  desc "Send daily notifications"
  task :daily => :environment do
    LetMeKnow::PeriodicSender.send_notifications :daily
  end

  desc "Send weekly notifications"
  task :weekly => :environment do
    if Time.zone.now.sunday?
      puts "sending weekly notifications"
      LetMeKnow::PeriodicSender.send_notifications :weekly
    else
      puts "skipping today"
    end
  end
end
