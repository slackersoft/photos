require 'spec_helper'

describe TagsController do
  describe "#show" do
    it "should render with all the photos" do
      get :show, tag_name: 'foo'
      response.should be_success
      assigns.should have_key(:photos)
      assigns[:photos].should == [photos(:mushroom), photos(:mohawk)]
    end
  end
end
