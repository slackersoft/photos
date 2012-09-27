require 'spec_helper'

module LetMeKnow
  describe InitialPreferences do
    describe ".after_create" do
      subject { described_class.new.after_create(preference_owner) }
      let(:preference_owner) { create(:user) }

      before do
        preference_owner.notification_preference.destroy
      end

      it "should create a notification preference that doesn't receive notifications" do
        expect { subject }.to change { preference_owner.reload.notification_preference }
        preference_owner.notification_preference.should_not be_send_notifications
      end
    end
  end
end
