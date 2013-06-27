namespace :let_me_know do
  [:daily, :weekly].each do |schedule|
    desc "Send #{schedule} notifications"
    task schedule =>:environment do
      LetMeKnow::PeriodicSender.send_notifications(schedule)
    end
  end
end
