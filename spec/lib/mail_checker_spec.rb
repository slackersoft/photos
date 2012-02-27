require 'spec_helper'

describe MailChecker do
  describe ".check_for_mail" do
    before do
      Mail.stub(:all).and_return(emails)
    end

    context "when there are messages" do
      let(:emails) { [double(Mail), double(Mail)] }
      
      it "should enqueue a job for each message" do
        Delayed::Job.should_receive(:enqueue).with(anything).twice

        MailChecker.check_for_mail
      end

      context "when there are no heroku background workers" do
        before do
          Heroku.stub(:workers).and_return(0)
        end

        it "should add a worker" do
          pending
          MailChecker.check_for_mail
        end
      end

      context "when there is at least one heroku background worker" do
        before do
          Heroku.stub(:workers).and_return(2)
        end

        it "should not add any workers" do
          pending
          MailChecker.check_for_mail
        end
      end
    end

    context "when there are no messages" do
      let(:emails) { [] }

      it "should not enqueue any jobs" do
        Delayed::Job.should_not_receive(:enqueue)

        MailChecker.check_for_mail
      end

      it "should not check herokus background workers" do
        Heroku.should_not_receive(:workers)
        
        MailChecker.check_for_mail
      end
    end
  end
end
