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
  end
end
