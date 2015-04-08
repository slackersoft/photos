require 'spec_helper'

module LetMeKnow
  describe PeriodicSender do
    describe ".send_notifications" do
      let!(:daily) { Notification.create!(subject: photos(:mohawk), notification_preference: create(:notification_preference, owner: users(:admin), schedule: :daily)) }
      let!(:weekly) { Notification.create!(subject: photos(:mohawk), notification_preference: create(:notification_preference, owner: users(:unauthorized), schedule: :weekly)) }

      context "when sending daily notifications" do
        let!(:daily2) { Notification.create!(subject: photos(:mohawk), notification_preference: create(:notification_preference, owner: users(:authorized), schedule: :daily)) }

        it "should send all daily notifications" do
          expect do
            described_class.send_notifications(:daily)
          end.to change { ActionMailer::Base.deliveries.count }.by(2)
          expect(daily.reload).to be_sent
          expect(daily2.reload).to be_sent
          expect(weekly.reload).not_to be_sent
        end
      end

      context "when sending weekly notifications" do
        let!(:weekly2) { Notification.create!(subject: photos(:mushroom), notification_preference: create(:notification_preference, owner: users(:authorized), schedule: :weekly)) }

        it "should send all weekly notifications" do
          expect do
            described_class.send_notifications(:weekly)
          end.to change { ActionMailer::Base.deliveries.count }.by(2)
          expect(weekly.reload).to be_sent
          expect(weekly2.reload).to be_sent
          expect(daily.reload).not_to be_sent
        end
      end

      context "when one user has more than one notification" do
        let!(:daily_double) { Notification.create!(subject: photos(:mushroom), notification_preference: daily.notification_preference) }

        it "should group all notifications into a single email" do
          expect do
            described_class.send_notifications(:daily)
          end.to change { ActionMailer::Base.deliveries.count }.by(1)
          expect(daily.reload).to be_sent
          expect(daily_double.reload).to be_sent
          expect(weekly.reload).not_to be_sent
        end
      end

      context "when a user has notifications that have already been sent" do
        let!(:sent_note) { Notification.create!(subject: photos(:mushroom), notification_preference: create(:notification_preference, owner: users(:admin), schedule: :daily), sent_at: Time.now) }

        it "should not re-send sent notifications" do
          expect(Mailer).to receive(:notify_bulk).with(:daily, anything) do |_, notifications|
            expect(notifications).not_to include(sent_note)
            double(:mail, deliver_now!: true)
          end
          described_class.send_notifications(:daily)
        end
      end
    end
  end
end
