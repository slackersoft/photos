require 'spec_helper'

describe MailChecker do
  before do
    allow(MailChecker).to receive(:log)
  end

  describe ".check_for_mail" do
    subject { lambda { MailChecker.check_for_mail } }

    before { Mail::TestRetriever.emails = emails.dup }

    context "when there are messages" do
      let(:sender_email) { users(:authorized).email }
      let(:email_subject) { '' }
      let(:email_body_text) { '' }
      let(:emails) do
        m = Mail.new({
          from: sender_email,
          subject: email_subject,
          to: 'photos@greggandjen.com',
          message_id: '123@test',
          body: email_body_text
        })
        to_attach.each { |name, value| m.add_file({ filename: name, content: File.read(Rails.root.join(value)) }) }
        [m]
      end

      context "when the mail has no attachments" do
        let(:to_attach) { { } }

        it { should_not change { Photo.count } }

        it "should delete the mail" do
          subject.call

          expect(Mail::TestRetriever.emails).to be_empty
        end
      end

      context "when the mail has only non-image attachments" do
        let(:to_attach) { { "foo.txt" => "/dev/null" } }

        it { should_not change { Photo.count } }

        it "should delete the mail" do
          subject.call

          expect(Mail::TestRetriever.emails).to be_empty
        end
      end

      context "when the mail has an image attachment" do
        let(:to_attach) { { "foo.png" => "spec/fixtures/files/mushroom.png" } }

        context "when the message is not from an allowed sender" do
          let(:sender_email) { 'someone@gmail.com' }
          it { should_not change { Photo.count } }

          it "should delete the mail" do
            subject.call

            expect(Mail::TestRetriever.emails).to be_empty
          end
        end

        context "when the message is from an allowed sender" do
          let(:sender_email) { users(:authorized).email }

          it { should change { Photo.count }.by(1) }

          it "should associate the photo with the sender" do
            subject.call
            expect(Photo.last.user).to eq users(:authorized)
          end

          it "should delete the mail" do
            subject.call

            expect(Mail::TestRetriever.emails).to be_empty
          end

          context "when the email has a blank subject" do
            let(:email_subject) { '' }

            it "should use the name of the attachment file for the photo name" do
              subject.call

              expect(Photo.last.name).to eq 'foo.png'
            end
          end

          context "when the email has a subject" do
            let(:email_subject) { 'My Foo Thing' }

            it "should use the subject and the photo name" do
              subject.call

              expect(Photo.last.name).to eq 'My Foo Thing'
            end

            context "when the email was forwarded" do
              let(:email_subject) { 'Fwd: My Foo Thing' }

              it "should not include the forwarding information" do
                subject.call

                expect(Photo.last.name).to eq 'My Foo Thing'
              end
            end

            context "when the subject looks like it has tags" do
              context "single tag at the beginning" do
                let(:email_subject) { '[Taggy] My Stuff' }

                it "should tag the photo and not have the tag in the name" do
                  subject.call

                  expect(Photo.last.name).to eq 'My Stuff'
                  expect(Photo.last).to have_tag('Taggy')
                end
              end

              context "multiple tags at the beginning" do
                let(:email_subject) { '[Taggy] [Stuff] My Stuff' }

                it "should tag the photo and not have the tag in the name" do
                  subject.call

                  expect(Photo.last.name).to eq 'My Stuff'
                  expect(Photo.last).to have_tag('Taggy')
                  expect(Photo.last).to have_tag('Stuff')
                end
              end

              context "single tag at the end" do
                let(:email_subject) { 'My Stuff [Taggy]' }

                it "should tag the photo and not have the tag in the name" do
                  subject.call

                  expect(Photo.last.name).to eq 'My Stuff'
                  expect(Photo.last).to have_tag('Taggy')
                end
              end

              context "multiple tags at the end" do
                let(:email_subject) { 'My Stuff [Taggy] [Stuff]' }

                it "should tag the photo and not have the tag in the name" do
                  subject.call

                  expect(Photo.last.name).to eq 'My Stuff'
                  expect(Photo.last).to have_tag('Taggy')
                  expect(Photo.last).to have_tag('Stuff')
                end
              end

              context "tag-like strings in the middle" do
                let(:email_subject) { 'My [Taggy] Stuff' }

                it "should not tag the photo or remove the tag-like string from the name" do
                  subject.call

                  expect(Photo.last.name).to eq 'My [Taggy] Stuff'
                  expect(Photo.last.tags).to eq []
                end
              end
            end
          end

          context "when the email has an empty body" do
            let(:body_text) { '' }

            it "should set the photo's description to be empty" do
              subject.call

              expect(Photo.last.description).to eq ''
            end
          end

          context "when the email has text in it" do
            let(:email_body_text) { 'this is some descriptive text' }

            it "should use the text as the description for the image" do
              subject.call

              expect(Photo.last.description).to eq email_body_text
            end

            context "with a signature" do
              let(:email_body_text) do
                <<-TEXT
                    this is a description
                     --
                    Some signature
                TEXT
              end

              it "should not include the signature in the description" do
                subject.call

                expect(Photo.last.description).to eq "this is a description"
              end
            end

            context "when the message was forwarded" do
              let(:email_body_text) do
                <<-TEXT
                    this is a description
                    ---------- Forwarded message ----------
                    Some other stuff
                TEXT
              end

              it "should not include the forwarding information" do
                subject.call

                expect(Photo.last.description).to eq "this is a description"
              end
            end
          end

          context "when the message has already been imported" do
            before do
              subject.call
              Mail::TestRetriever.emails = emails.dup
            end

            it { should_not change { Photo.count } }
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
