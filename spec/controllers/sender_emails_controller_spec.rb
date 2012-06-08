require 'spec_helper'

describe SenderEmailsController do
  let(:user) { users(:authorized) }
  before do
    sign_in user
  end

  describe "#create" do
    subject { post :create, user_id: user.id, sender_email: { address: 'foo@bar.com' } }

    it "should create a sender email for the user" do
      lambda { subject }.should change { user.reload.sender_emails.count }.by(1)
      user.sender_emails.last.address.should == 'foo@bar.com'
    end

    it "should redirect to the account page" do
      subject
      response.should redirect_to(account_path)
    end
  end

  describe "#destroy" do
    subject { delete :destroy, user_id: user.id, id: email.id }
    let!(:email) { user.sender_emails.create(address: 'blah@blah.com') }

    it "should remove the email address" do
      lambda { subject }.should change { user.reload.sender_emails.count }.by(-1)
      user.sender_emails.map(&:address).should_not include('blah@blah.com')
    end

    it "should redirect to the account page" do
      subject
      response.should redirect_to(account_path)
    end
  end
end
