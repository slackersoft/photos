require 'spec_helper'

describe NotificationPreferencesController do
  describe "#create" do
    subject { post :create, notification_preference: { send_notifications: '1' } }

    context "when not logged in" do
      before do
        sign_out :user
      end

      it { should redirect_to(root_path) }
    end

    context "when signed in" do
      let(:user) {users(:unauthorized)}
      before do
        sign_in user
      end

      it { should redirect_to(account_path) }

      it "should create a notification preference for the logged in user" do
        expect { subject }.to change { user.reload.notification_preference }
        user.notification_preference.should be_send_notifications
      end
    end
  end

  describe "#update" do
    subject { put :update, notification_preference: { send_notifications: '1' } }

    context "when not logged in" do
      before do
        sign_out :user
      end

      it { should redirect_to(root_path) }
    end

    context "when signed in" do
      let(:user) {users(:unauthorized)}
      before do
        sign_in user
      end

      it "should update the user" do
        user.create_notification_preference(send_notifications: false)
        subject
        response.should redirect_to(account_path)
        user.reload.notification_preference.should be_send_notifications
      end
    end
  end
end
