require "spec_helper"

describe PhotosController do
  describe "#show" do
    let!(:photo1) { Photo.create!(:name => "foo", :image => File.open(File.join(Rails.root, "spec", "fixtures", "files", "mushroom.png"))) }
    let!(:photo2) { Photo.create!(:name => "bar", :image => File.open(File.join(Rails.root, "spec", "fixtures", "files", "mushroom.png"))) }

    it "should render with all the photos" do
      get :show, id: photo2.to_param
      response.should be_success
      assigns.should have_key(:photos)
    end
  end
end
