require 'spec_helper'

module LetMeKnow
  describe Mailer do
    describe "#notify" do
      let(:notification) { Notification.new(subject: notification_subject, notification_preference: preference) }
      let(:recipient) { users(:unauthorized) }
      let(:preference) { create(:notification_preference, owner: recipient) }
      let(:notification_subject) { photos(:mohawk) }

      subject { described_class.notify(notification) }

      its(:subject) { should == "New photo added" }
      its(:from) { should == %w(photos@greggandjen.com) }
      its(:to) { should == [recipient.email] }
      its(:body) do
        should include("#{notification_subject.user.name} has added a new photo")
        should include("See more")
      end

      context "dynamicness of subject" do
        let(:notification_subject) do
          CrazyPhoto = Class.new(Photo)
          CrazyPhoto.new(attributes_for(:photo).merge(user: users(:authorized)))
        end
        its(:subject) { should == "New crazy photo added" }
      end
    end

    describe "#notify_bulk" do
      let(:notifications) do
        [
          Notification.new(subject: photos(:mohawk), notification_preference: preference),
          Notification.new(subject: photos(:mushroom), notification_preference: preference),
          Notification.new(subject: second_photo_for_user, notification_preference: preference)
        ]
      end
      let(:second_photo_for_user) { create(:photo, user: photos(:mohawk).user, name: 'another one') }
      let(:recipient) { users(:unauthorized) }
      let(:preference) { create(:notification_preference, owner: recipient) }
      let(:schedule) { :daily }
      let(:either_user_name_regex) { "(#{photos(:mohawk).user.name}|#{photos(:mushroom).user.name})" }

      subject { described_class.notify_bulk(schedule, notifications) }

      its(:subject) { should == "New photos added in the last day" }
      its(:from) { should == %w(photos@greggandjen.com) }
      its(:to) { should == [recipient.email] }

      its(:body) do
        should match(/^New photos have been added by #{either_user_name_regex} and #{either_user_name_regex}$/)
      end

      context "when sending from a weekly schedule" do
        let(:schedule) { :weekly }
        its(:subject) { should == "New photos added in the last week" }
      end

      context "when one of the subjects no longer exists" do
        let(:second_photo_for_user) { nil }

        its(:body) do
          should match(/^New photos have been added by #{either_user_name_regex} and #{either_user_name_regex}$/)
        end
      end
    end
  end
end
