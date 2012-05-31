require 'spec_helper'

describe AccountsController do
  describe "#show" do
    subject { get :show }

    context "when not logged in" do
      before do
        sign_out :user
      end

      it { should redirect_to(root_path) }
    end

    context "when signed in" do
      before do
        sign_in users(:unauthorized)
      end

      it { should be_success }
    end
  end

  describe "#update" do
    subject { put :update, user: { name: 'Foo' } }

    context "when not logged in" do
      before do
        sign_out :user
      end

      it { should redirect_to(root_path) }

      it "should not update any user" do
        User.where(name: 'Foo').should == []
      end
    end

    context "when signed in" do
      before do
        sign_in users(:unauthorized)
      end

      it "should update the user" do
        subject
        response.should redirect_to(root_path)
        users(:unauthorized).reload.name.should == 'Foo'
      end
    end
  end
end
