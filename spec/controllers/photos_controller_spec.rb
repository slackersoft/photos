require "spec_helper"

describe PhotosController do
  describe "#index" do
    let!(:photo1) { Photo.create!(name: "foo", image: File.open(File.join(Rails.root, "spec", "fixtures", "files", "mushroom.png"))) }
    let!(:photo2) { Photo.create!(name: "bar", image: File.open(File.join(Rails.root, "spec", "fixtures", "files", "mushroom.png"))) }

    it "should show all of the existing photos in order" do
      get :index
      response.should be_success
      assigns.should have_key(:photos)
      assigns[:photos].should =~ [photo1, photo2]
    end
  end
end
