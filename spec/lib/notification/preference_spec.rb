require 'spec_helper'

describe Notification::Preference do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    before do
      subject.user = users(:unauthorized)
      subject.send_notifications = true
    end

    it { should validate_presence_of(:user) }
    it { should allow_value(:immediately).for(:schedule) }
    it { should allow_value(:daily).for(:schedule) }
    it { should allow_value(:weekly).for(:schedule) }
    it { should_not allow_value(:monthly).for(:schedule) }
    it { should validate_presence_of(:send_notifications) }

    context "when send_notifications is true" do
      before do
        subject.send_notifications = true
      end

      it "should require schedule to be set" do
        subject.schedule = nil
        subject.should_not be_valid
        subject.should have(1).error_on(:schedule)
      end
    end

    context "when send_notifications is false" do
      before do
        subject.send_notifications = false
      end

      it "should set the schedule to nil" do
        subject.schedule = :immediate
        subject.valid?
        subject.schedule.should be_nil
        subject.should have(0).errors_on(:schedule)
      end
    end
  end
end
