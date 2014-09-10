require 'spec_helper'

describe RootsController do
  describe "#index" do
    it "should render with all the photos" do
      get :index
      expect(response).to be_success
      expect(assigns).to have_key(:photos)
      expect(assigns[:photos]).to eq [photos(:mushroom), photos(:mohawk)]
    end
  end
end
