class MailChecker
  def self.check_for_mail
    Mail.all.each do |mail|
      Delayed::Job.enqueue mail
    end
  end
end
