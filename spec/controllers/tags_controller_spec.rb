require 'spec_helper'

describe TagsController do
  describe "#show" do
    it "should render with all the photos" do
      get :show, tag_name: 'foo'
      expect(response).to be_success
      expect(assigns).to have_key(:photos)
      expect(assigns[:photos]).to eq [photos(:mushroom), photos(:mohawk)]
    end
  end
end
