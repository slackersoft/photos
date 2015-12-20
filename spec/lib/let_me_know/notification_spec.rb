require 'spec_helper'

module LetMeKnow
  describe Notification do
    describe "associations" do
      it { should belong_to(:subject) }
      it { should belong_to(:notification_preference).class_name('LetMeKnow::Preference') }
    end

    describe "validations" do
      it { should validate_presence_of(:notification_preference) }
    end

    describe "#sent?" do
      context "when sent_at is set" do
        before do
          subject.sent_at = Time.now
        end

        it { should be_sent }
      end

      context "when sent_at is not set" do
        before do
          subject.sent_at = nil
        end

        it { should_not be_sent }
      end
    end

    describe "#send_notification" do
      let(:mohawk) { create(:photo) }
      let(:admin) { create(:admin) }
      let(:notification) { Notification.create(subject: mohawk, notification_preference: create(:notification_preference, owner: admin), sent_at: nil) }

      it "should send the notification" do
        expect { notification.send_notification }.to change { ActionMailer::Base.deliveries.count }.by(1)
        expect(ActionMailer::Base.deliveries.last.subject).to eq "New photo added"
      end

      it "should mark the notification as sent" do
        notification.send_notification
        expect(notification.reload).to be_sent
      end

      context "when it has already been sent" do
        before do
          notification.update_attribute :sent_at, Time.now - 1.day
        end

        it "should not send again" do
          expect { notification.send_notification }.to_not change { ActionMailer::Base.deliveries.count }
        end
      end
    end

    describe ".unsent" do
      let(:mohawk) { create(:photo) }
      let(:mushroom) { create(:photo, name: 'mushroom', image: File.new(Rails.root.join('spec', 'fixtures', 'files', 'mushroom.png'))) }
      let(:admin) { create(:admin) }
      let!(:unsent) { Notification.create(subject: mohawk, notification_preference: create(:notification_preference, owner: admin)) }
      let!(:sent) { Notification.create(subject: mushroom, notification_preference: create(:notification_preference, owner: admin), sent_at: Time.now) }

      it "should not include notifications that have been sent" do
        expect(Notification.unsent).to eq [unsent]
      end
    end

    describe ".scheduled_as" do
      let(:mohawk) { create(:photo) }
      let(:admin) { create(:admin) }
      let(:authorized) { create(:authorized) }
      let(:unauthorized) { create(:user) }
      let!(:daily) { Notification.create!(subject: mohawk, notification_preference: create(:notification_preference, owner: admin, schedule: :daily)) }
      let!(:weekly) { Notification.create!(subject: mohawk, notification_preference: create(:notification_preference, owner: unauthorized, schedule: :weekly)) }
      let!(:immediately) { Notification.create!(subject: mohawk, notification_preference: create(:notification_preference, owner: authorized, schedule: :immediately)) }

      it "should only include notifications whose recipient wants notifications on the given schedule" do
        expect(Notification.scheduled_as(:daily)).to eq [daily]
        expect(Notification.scheduled_as(:weekly)).to eq [weekly]
        expect(Notification.scheduled_as(:immediately)).to eq [immediately]
      end

      it "should not return readonly records" do
        Notification.scheduled_as(:daily).each do |notification|
          expect(notification).not_to be_readonly
        end
      end
    end

    describe "lifecycle callbacks" do
      context "sending immediately" do
        let(:mohawk) { create(:photo) }
        let(:admin) { create(:admin) }
        let(:authorized) { create(:authorized) }
        let(:unauthorized) { create(:user) }
        let!(:daily) { Notification.new(subject: mohawk, notification_preference: create(:notification_preference, owner: admin, schedule: :daily)) }
        let!(:weekly) { Notification.new(subject: mohawk, notification_preference: create(:notification_preference, owner: unauthorized, schedule: :weekly)) }
        let(:immediately) { Notification.new(subject: mohawk, notification_preference: create(:notification_preference, owner: authorized, schedule: :immediately)) }

        it "should only send immediately when appropriate" do
          expect { daily.save! }.to_not change { ActionMailer::Base.deliveries.count }
          expect { weekly.save! }.to_not change { ActionMailer::Base.deliveries.count }
          expect { immediately.save! }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end
    end
  end
end
