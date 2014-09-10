require 'spec_helper'

describe SenderEmailsController do
  let(:user) { users(:authorized) }
  before do
    sign_in user
  end

  describe "#create" do
    subject { post :create, user_id: user.id, sender_email: { address: 'foo@bar.com' } }

    it "should create a sender email for the user" do
      expect { subject }.to change { user.reload.sender_emails.count }.by(1)
      expect(user.sender_emails.last.address).to eq 'foo@bar.com'
    end

    it "should redirect to the account page" do
      subject
      expect(response).to redirect_to(account_path)
    end
  end

  describe "#destroy" do
    subject { delete :destroy, user_id: user.id, id: email.id }
    let!(:email) { user.sender_emails.create(address: 'blah@blah.com') }

    it "should remove the email address" do
      expect { subject }.to change { user.reload.sender_emails.count }.by(-1)
      expect(user.sender_emails.map(&:address)).not_to include('blah@blah.com')
    end

    it "should redirect to the account page" do
      subject
      expect(response).to redirect_to(account_path)
    end
  end
end
