require 'spec_helper'

module LetMeKnow
  describe MakeNotifications do
    describe "#after_commit" do
      subject { described_class.new.after_commit(notification_subject) }
      let(:notification_subject) { photos(:mohawk) }
      let(:notify1) { users(:admin).notification_preference }
      let(:notify2) { users(:unauthorized).notification_preference }
      let(:dont_notify) { users(:authorized).notification_preference }

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
