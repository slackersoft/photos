desc "Check for new photo email messages"
task :check_mail => :environment do
  MailChecker.check_for_mail
end
