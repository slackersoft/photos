require 'spec_helper'

module LetMeKnow
  describe MakeNotifications do
    describe "#after_commit" do
      subject { described_class.new.after_commit(notification_subject) }
      let!(:notification_subject) { create(:photo) }
      let!(:notify1) do
        user = create(:user)
        user.notification_preference.update_attributes(send_notifications: true, schedule: :daily)
        user.notification_preference
      end
      let!(:notify2) do
        user = create(:user)
        user.notification_preference.update_attributes(send_notifications: true, schedule: :daily)
        user.notification_preference
      end
      let!(:dont_notify) { create(:user).notification_preference }

      it "should create notifications for users that receive notifications" do
        expect { subject }.to change { Notification.count }.by(2)
        expect(dont_notify.reload.notifications).to be_empty
        expect(notify1.reload.notifications.count).to eq 1
        expect(notify2.reload.notifications.count).to eq 1
      end

      it "should not notify the owner of the subject" do
        notification_subject.update_attributes(user: notify1.owner)
        expect { subject }.to change { Notification.count }.by(1)
        expect(dont_notify.reload.notifications).to be_empty
        expect(notify1.reload.notifications).to be_empty
        expect(notify2.reload.notifications.count).to eq 1
      end
    end
  end
end
