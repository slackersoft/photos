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
end
