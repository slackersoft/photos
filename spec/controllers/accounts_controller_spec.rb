require 'spec_helper'

describe AccountsController do
  describe "#show" do
    subject(:show) { get :show }

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

      context "when there are saved errors for notification preferences" do
        before do
          pending "flash messages aren't making it to the controller"
          flash[:form_errors] = { notification_preference: { foo: ['bar baz'] } }
        end

        it "should add the errors to the user's notification preference" do
          show
          controller.current_user.notification_preference.errors(:foo).should == ['bar baz']
        end
      end
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
