namespace :let_me_know do
  desc "Send daily notifications"
  task :daily => :environment do
    LetMeKnow::PeriodicSender.send_notifications :daily
  end

  desc "Send weekly notifications"
  task :weekly => :environment do
    LetMeKnow::PeriodicSender.send_notifications :weekly if Date.today.sunday?
  end
end
