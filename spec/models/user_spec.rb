require 'spec_helper'

describe User do
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
end
