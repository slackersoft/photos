require 'spec_helper'

module LetMeKnow
  describe Preference do
    describe "associations" do
      it { should belong_to(:owner) }
      it { should have_many(:notifications) }
      it { should have_many(:unsent_notifications) }
    end

    describe "validations" do
      before do
        subject.owner = create(:user)
        subject.send_notifications = true
      end

      it { should validate_presence_of(:owner) }
      it { should allow_value(:immediately).for(:schedule) }
      it { should allow_value(:daily).for(:schedule) }
      it { should allow_value(:weekly).for(:schedule) }
      it { should allow_value('weekly').for(:schedule) }
      it { should_not allow_value(:monthly).for(:schedule) }
      it { should allow_value(true).for(:send_notifications) }
      it { should allow_value(false).for(:send_notifications) }
      it { should_not allow_value(nil).for(:send_notifications) }

      context "when send_notifications is true" do
        before do
          subject.send_notifications = true
        end

        it "should require schedule to be set" do
          subject.schedule = nil
          expect(subject).not_to be_valid
          expect(subject.errors[:schedule].size).to eq 1
        end
      end

      context "when send_notifications is false" do
        before do
          subject.send_notifications = false
        end

        it "should set the schedule to nil" do
          subject.schedule = :immediate
          subject.valid?
          expect(subject.schedule).to be_nil
          expect(subject.errors[:schedule].size).to eq 0
        end
      end
    end

    describe "#immediate?" do
      context "when the schedule is immediate" do
        before do
          subject.schedule = :immediately
        end

        it { should be_immediate }
      end

      (Preference.schedule_options - [:immediately]).each do |schedule|
        context "when the schedule is #{schedule}" do
          before do
            subject.schedule = schedule
          end

          it { should_not be_immediate }
        end
      end
    end
  end
end
