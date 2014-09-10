require 'spec_helper'

describe User do
  describe "validations" do
    it { should validate_presence_of(:email) }
  end

  describe "associations" do
    it { should have_many(:sender_emails) }
    it { should have_many(:photos) }
  end

  describe "lifecycle callbacks" do
    let(:user) { create(:user) }

    it "should create a sender email for email" do
      expect { user }.to change{SenderEmail.count}.by(1)
      expect(SenderEmail.last.user).to eq user
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
        expect { subject }.not_to change { User.count }
      end

      it "should return the matching user" do
        should eq users(:unauthorized)
      end
    end

    context "when the user doesn't exist" do
      let(:email) { 'foobar@baz.com' }

      it "should create a corresponding user" do
        expect { subject }.to change { User.count }.by(1)
        expect(User.last.email).to eq email
      end

      it "should return the created user" do
        expect(subject).to eq User.last
      end
    end
  end

  describe "#display_name" do
    let(:user) { create(:user, name: name) }
    subject { user.display_name }

    context "when the user has a name" do
      let(:name) { 'Foo Bar' }

      it { should eq name }
    end

    context "when the user does not have a name" do
      let(:name) { nil }

      it { should eq user.email }
    end
  end

  describe ".authorized" do
    it "should only return users who are authorized" do
      expect(User.authorized).to match_array [users(:admin), users(:authorized)]
    end
  end

  describe ".with_email" do
    it "should return the user who owns the specified sender email" do
      expect(User.with_email('still@unauthorized.com')).to eq users(:unauthorized)
    end
  end
end
