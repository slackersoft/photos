require 'spec_helper'

describe RootsController do
  describe "#index" do
    it "should render with all the photos" do
      get :index
      response.should be_success
      assigns.should have_key(:photos)
      assigns[:photos].should == [photos(:mushroom), photos(:mohawk)]
    end
  end
end
