require 'spec_helper'

module LetMeKnow
  describe PeriodicSender do
    describe ".send_notifications" do
      let!(:daily1) { Notification.create!(subject: photos(:mohawk), notification_preference: create(:notification_preference, owner: users(:admin), schedule: :daily)) }
      let!(:daily2) { Notification.create!(subject: photos(:mushroom), notification_preference: create(:notification_preference, owner: users(:admin), schedule: :daily)) }
      let!(:weekly1) { Notification.create!(subject: photos(:mohawk), notification_preference: create(:notification_preference, owner: users(:unauthorized), schedule: :weekly)) }
      let!(:weekly2) { Notification.create!(subject: photos(:mushroom), notification_preference: create(:notification_preference, owner: users(:unauthorized), schedule: :weekly)) }

      context "when sending daily notifications" do
        it "should send all daily notifications" do
          expect do
            described_class.send_notifications(:daily)
          end.to change { ActionMailer::Base.deliveries.count }.by(2)
          daily1.reload.should be_sent
          daily2.reload.should be_sent
          weekly1.reload.should_not be_sent
          weekly2.reload.should_not be_sent
        end
      end

      context "when sending weekly notifications" do
        it "should send all weekly notifications" do
          expect do
            described_class.send_notifications(:weekly)
          end.to change { ActionMailer::Base.deliveries.count }.by(2)
          weekly1.reload.should be_sent
          weekly2.reload.should be_sent
          daily1.reload.should_not be_sent
          daily2.reload.should_not be_sent
        end
      end
    end
  end
end
