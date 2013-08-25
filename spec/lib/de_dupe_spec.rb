require 'spec_helper'

describe DeDupe do
  describe "notifications" do
    let(:user) { users(:admin) }
    let(:photo) { photos(:mohawk) }

    context "when a user has duplicate unsent notifications" do
      before do
        LetMeKnow::Notification.create(subject: photo, notification_preference: user.notification_preference)
        LetMeKnow::Notification.create(subject: photo, notification_preference: user.notification_preference)
        LetMeKnow::Notification.create(subject: photo, notification_preference: user.notification_preference)
      end

      it "should leave only one notification" do
        expect {
          DeDupe.notifications
        }.to change {
          user.notification_preference.unsent_notifications.count
        }.from(3).to(1)
      end
    end

    context "when a user has multiple unrelated unsent notifications" do
      let(:other_photo) { photos(:mushroom) }
      before do
        LetMeKnow::Notification.create(subject: photo, notification_preference: user.notification_preference)
        LetMeKnow::Notification.create(subject: other_photo, notification_preference: user.notification_preference)
      end

      it "should leave both notifications" do
        expect {
          DeDupe.notifications
        }.not_to change {
          user.notification_preference.unsent_notifications.count
        }
      end
    end
  end
end
