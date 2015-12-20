require 'spec_helper'

describe RootsController do
  describe "#index" do
    it "should render with all the photos" do
      mohawk = create(:photo)
      mushroom = create(:photo)

      get :index
      expect(response).to be_success
      expect(assigns).to have_key(:photos)
      expect(assigns[:photos]).to eq [mushroom, mohawk]
    end
  end
end
