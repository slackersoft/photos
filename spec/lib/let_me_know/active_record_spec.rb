require 'spec_helper'

module LetMeKnow
  class TestRecipient < ::ActiveRecord::Base
    self.table_name = :notifications
    extend ::LetMeKnow::ActiveRecord
    notification_recipient
  end

  class TestSubject < ::ActiveRecord::Base
    self.table_name = :notification_preferences
    extend ::LetMeKnow::ActiveRecord
    notification_subject
  end

  describe "ActiveRecord" do
    describe TestRecipient do
      it { should have_one(:notification_preference).class_name("LetMeKnow::Preference").dependent(:destroy) }
    end

    describe TestSubject do
      it { should have_many(:notifications).class_name("LetMeKnow::Notification").dependent(:destroy) }
    end
  end
end
