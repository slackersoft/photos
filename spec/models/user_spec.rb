require 'spec_helper'

describe User do
  describe "validations" do
    it { should validate_presence_of(:email) }
  end

  describe "associations" do
    it { should have_many(:sender_emails) }
  end

  describe "lifecycle callbacks" do
    let(:user) { create(:user) }

    it "should create a sender email for email" do
      lambda { user }.should change{SenderEmail.count}.by(1)
      SenderEmail.last.user.should == user
    end
  end

  describe ".find_for_open_id" do
    subject do
      User.find_for_open_id(auth_hash)
    end

    let(:auth_hash) do
      auth = OmniAuth.mock_auth_for(:default)
      auth.info['email'] = email
      auth
    end

    context "when the user exists" do
      let(:email) { users(:unauthorized).email }

      it "should not create a user" do
        lambda { subject }.should_not change { User.count }
      end

      it "should return the matching user" do
        should == users(:unauthorized)
      end
    end

    context "when the user doesn't exist" do
      let(:email) { 'foobar@baz.com' }

      it "should create a corresponding user" do
        lambda { subject }.should change { User.count }.by(1)
        User.last.email.should == email
      end

      it "should return the created user" do
        subject.should == User.last
      end
    end
  end

  describe "#display_name" do
    let(:user) { create(:user, name: name) }
    subject { user.display_name }

    context "when the user has a name" do
      let(:name) { 'Foo Bar' }

      it { should == name }
    end

    context "when the user does not have a name" do
      let(:name) { nil }

      it { should == user.email }
    end
  end

  describe ".authorized" do
    it "should only return users who are authorized" do
      User.authorized.should =~ [users(:admin), users(:authorized)]
    end
  end
end
