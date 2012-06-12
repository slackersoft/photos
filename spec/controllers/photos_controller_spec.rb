require "spec_helper"

describe PhotosController do
  describe "#show" do
    it "should render with all the photos" do
      get :show, id: 'foo'
      response.should be_success
      assigns.should have_key(:photos)
      assigns[:photos].should == [photos(:mushroom), photos(:mohawk)]
    end
  end

  describe "#delete" do
    let!(:photo) { create(:photo) }
    subject { xhr :delete, :destroy, id: photo.id }

    context "when signed in as an admin user" do
      before do
        sign_in users(:admin)
      end

      it "should delete the photo" do
        lambda { subject }.should change { Photo.count }.by(-1)
        response.should be_success
      end
    end

    context "when signed in as a non-admin user" do
      before do
        sign_in users(:authorized)
      end

      it "should not delete the photo and return unauthorized" do
        lambda { subject }.should_not change { Photo.count }
        response.code.should == '403'
      end
    end

    context "when not signed in" do
      before do
        sign_out :user
      end

      it "should not delete the photo and return unauthorized" do
        lambda { subject }.should_not change { Photo.count }
        response.code.should == '403'
      end
    end
  end

  describe "#add_tag" do
    let(:photo) { photos(:mohawk) }
    let(:tag) { 'hi' }

    subject { xhr :post, :add_tag, id: photo.id, tag: tag }

    context "when signed in as an authorized user" do
      before do
        sign_in users(:authorized)
      end

      it "should add the tag" do
        lambda { subject }.should change { photo.reload.tags.size }.by(1)
        response.should be_success
        photo.tags.last.should == 'hi'
      end

      it "should render the updated photo as json" do
        subject
        response.should be_success
        photo_json = JSON.parse(response.body)
        photo_json['tags'].should == %w(hi)
      end
    end

    context "when signed in as an unauthorized user" do
      before do
        sign_in users(:unauthorized)
      end

      it "should not add the tag and fail with unauthorized" do
        lambda { subject }.should_not change { photo.reload.tags.size }
        response.code.should == '403'
      end
    end

    context "when not signed in" do
      before do
        sign_out :user
      end

      it "should not add the tag and fail with unauthorized" do
        lambda { subject }.should_not change { photo.reload.tags.size }
        response.code.should == '403'
      end
    end
  end

  describe "#remove_tag" do
    let(:photo) { photos(:mushroom) }
    let(:tag) { tags(:tag).name }

    subject { xhr :post, :remove_tag, id: photo.id, tag: tag }

    describe "when signed in as an authorized user" do
      before do
        sign_in users(:authorized)
      end

      it "should remove the tag" do
        lambda { subject }.should change { photo.reload.tags.size }.by(-1)
        response.should be_success
        photo.tags.should == []
      end

      it "should render the updated photo as json" do
        subject
        response.should be_success
        photo_json = JSON.parse(response.body)
        photo_json['tags'].should == []
      end
    end

    context "when signed in as an unauthorized user" do
      before do
        sign_in users(:unauthorized)
      end

      it "should not add the tag and fail with unauthorized" do
        lambda { subject }.should_not change { photo.reload.tags.size }
        response.code.should == '403'
      end
    end

    context "when not signed in" do
      before do
        sign_out :user
      end

      it "should not add the tag and fail with unauthorized" do
        lambda { subject }.should_not change { photo.reload.tags.size }
        response.code.should == '403'
      end
    end
  end
end
