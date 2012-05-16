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
end
