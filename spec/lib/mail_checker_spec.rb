require 'spec_helper'

describe MailChecker do
  describe ".check_for_mail" do
    subject { lambda { MailChecker.check_for_mail } }

    before { Mail::TestRetriever.emails = emails.dup }

    context "when there are messages" do
      let(:sender_email) { 'gregg@greggandjen.com' }
      let(:email_subject) { '' }
      let(:emails) do
        m = Mail.new({
          from: sender_email,
          subject: email_subject,
          to: 'photos@greggandjen.com'
        })
        to_attach.each { |name, value| m.attachments[name] = File.read(Rails.root.join(value)) }
        [m]
      end

      context "when the mail has no attachments" do
        let(:to_attach) { { } }

        it { should_not change { Photo.count } }

        it "should delete the mail" do
          subject.call

          Mail::TestRetriever.emails.should be_empty
        end
      end

      context "when the mail has only non-image attachments" do
        let(:to_attach) { { "foo.txt" => "/dev/null" } }

        it { should_not change { Photo.count } }

        it "should delete the mail" do
          subject.call

          Mail::TestRetriever.emails.should be_empty
        end
      end

      context "when the mail has an image attachment" do
        let(:to_attach) { { "foo.png" => "spec/fixtures/files/mushroom.png" } }

        context "when the message is not from an allowed sender" do
          let(:sender_email) { 'someone@gmail.com' }
          it { should_not change { Photo.count } }

          it "should delete the mail" do
            subject.call

            Mail::TestRetriever.emails.should be_empty
          end
        end

        context "when the message is from an allowed sender" do
          %w(gregg@greggandjen.com jen@greggandjen.com).each do |approved_sender_email|
            context "sender: #{approved_sender_email}" do
              let(:sender_email) { approved_sender_email }

              it { should change { Photo.count }.by(1) }

              context "when the email has a blank subject" do
                let(:email_subject) { '' }

                it "should use the name of the attachment file for the photo name" do
                  subject.call

                  Photo.last.name.should == 'foo.png'
                end
              end

              context "when the email has a subject" do
                let(:email_subject) { 'My Foo Thing' }

                it "should use the subject and the photo name" do
                  subject.call

                  Photo.last.name.should == 'My Foo Thing'
                end
              end

              it "should delete the mail" do
                subject.call

                Mail::TestRetriever.emails.should be_empty
              end
            end
          end
        end
      end
    end

    context "when there are no messages" do
      let(:emails) { [] }

      it { should_not change { Photo.count } }
    end
  end
end
