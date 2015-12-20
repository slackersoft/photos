require 'spec_helper'

module LetMeKnow
  describe Mailer do
    describe "#notify" do
      let(:notification) { Notification.new(subject: notification_subject, notification_preference: preference) }
      let(:recipient) { create(:user) }
      let(:preference) { create(:notification_preference, owner: recipient) }
      let(:notification_subject) { create(:photo) }

      subject { described_class.notify(notification) }

      it 'should have the right fields' do
        expect(subject.subject).to eq 'New photo added'
        expect(subject.from).to eq %w(photos@greggandjen.com)
        expect(subject.to).to eq [recipient.email]
        expect(subject.body).to include "#{notification_subject.user.name} has added a new photo"
        expect(subject.body).to include "See more"
      end

      context "with a custom notification subject" do
        let(:notification_subject) do
          CrazyPhoto = Class.new(Photo)
          CrazyPhoto.new(attributes_for(:photo).merge(user: create(:user)))
        end

        it 'should update the email subject' do
          expect(subject.subject).to eq 'New crazy photo added'
        end
      end
    end

    describe "#notify_bulk" do
      let(:notifications) do
        [
          Notification.new(subject: mohawk, notification_preference: preference),
          Notification.new(subject: mushroom, notification_preference: preference),
          Notification.new(subject: second_photo_for_user, notification_preference: preference)
        ]
      end
      let(:mohawk) { create(:photo) }
      let(:mushroom) { create(:photo, name: 'mushroom') }
      let(:second_photo_for_user) { create(:photo, user: mohawk.user, name: 'another one') }
      let(:recipient) { create(:user) }
      let(:preference) { create(:notification_preference, owner: recipient) }
      let(:schedule) { :daily }
      let(:either_user_name_regex) { "(#{mohawk.user.name}|#{mushroom.user.name})" }

      subject { described_class.notify_bulk(schedule, notifications) }

      it 'should have the right fields' do
        expect(subject.subject).to eq "New photos added in the last day"
        expect(subject.from).to eq %w(photos@greggandjen.com)
        expect(subject.to).to eq [recipient.email]
        expect(subject.body).to match(/^New photos have been added by #{either_user_name_regex} and #{either_user_name_regex}$/)
      end

      context "when sending from a weekly schedule" do
        let(:schedule) { :weekly }

        it 'should have the right subject' do
          expect(subject.subject).to eq 'New photos added in the last week'
        end
      end

      context "when one of the subjects no longer exists" do
        let(:second_photo_for_user) { nil }

        it 'should have the right content' do
          expect(subject.body).to match(/^New photos have been added by #{either_user_name_regex} and #{either_user_name_regex}$/)
        end
      end
    end
  end
end
