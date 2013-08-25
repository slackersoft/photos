namespace :de_dupe do
  desc "De-duplicate unsent notifications"
  task :notifications => :environment do
    DeDupe.notifications
  end
end
