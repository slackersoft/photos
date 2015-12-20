require 'spec_helper'

describe LetMeKnow::PreferencesController, type: :controller do
  describe "creating" do
    subject(:create) { put :create, let_me_know_preference: { send_notifications: 1, schedule: 'immediately' } }

    context "not logged in" do
      before { sign_out :user }

      it { should redirect_to(root_path) }
    end

    context "signed in" do
      before do
        request.env['HTTP_REFERER'] = account_url
        sign_in user
        user.create_notification_preference(send_notifications: 0)
      end
      let!(:user) { FactoryGirl.create(:authorized) }

      it "should update the notification preferences" do
        create
        user.reload
        expect(user.notification_preference).to be_send_notifications
        expect(user.notification_preference).to be_immediate
      end

      it { should redirect_to(:back) }

      context "when invalid" do
        subject(:create) { put :create, let_me_know_preference: { send_notifications: 1 } }

        it { should redirect_to(:back) }

        it "should add the errors to the flash" do
          create
          expect(flash[:form_errors]).to have_key(:notification_preference)
          expect(flash[:form_errors][:notification_preference]).to eq({ schedule: ["can't be blank when receiving notifications"] })
        end
      end
    end
  end

  describe "updating" do
    subject(:update) { post :update, let_me_know_preference: { send_notifications: 1, schedule: 'immediately' } }

    context "not logged in" do
      before { sign_out :user }

      it { should redirect_to(root_path) }
    end

    context "signed in" do
      before do
        request.env['HTTP_REFERER'] = account_url
        sign_in user
        user.create_notification_preference(send_notifications: 0)
      end
      let!(:user) { create(:authorized) }

      it "should update the notification preferences" do
        update
        user.notification_preference.reload
        expect(user.notification_preference).to be_send_notifications
        expect(user.notification_preference).to be_immediate
      end

      it { should redirect_to(:back) }

      context "when invalid" do
        subject(:update) { post :update, let_me_know_preference: { send_notifications: 1 } }

        it { should redirect_to(:back) }

        it "should add the errors to the flash" do
          update
          expect(flash[:form_errors]).to have_key(:notification_preference)
          expect(flash[:form_errors][:notification_preference]).to eq({ schedule: ["can't be blank when receiving notifications"] })
        end
      end
    end
  end
end
