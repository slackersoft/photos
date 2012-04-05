require 'spec_helper'

describe RootsController do
  describe "#index" do
    let!(:photo1) { Photo.create!(:name => "foo", :image => File.open(File.join(Rails.root, "spec", "fixtures", "files", "mushroom.png"))) }
    let!(:photo2) { Photo.create!(:name => "bar", :image => File.open(File.join(Rails.root, "spec", "fixtures", "files", "mushroom.png"))) }

    it "should render with all the photos" do
      get :index
      response.should be_success
      assigns.should have_key(:photos)
    end
  end
end
