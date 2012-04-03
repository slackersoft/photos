require "spec_helper"

describe PhotosController do
  describe "#index" do
    let!(:photo1) { Photo.create!(:name => "foo", :image => File.open(File.join(Rails.root, "spec", "fixtures", "files", "mushroom.png"))) }
    let!(:photo2) { Photo.create!(:name => "bar", :image => File.open(File.join(Rails.root, "spec", "fixtures", "files", "mushroom.png"))) }

    it "should show all of the existing photos in order" do
      xhr :get, :index
      response.should be_success
      JSON.parse(response.body).map(&:symbolize_keys).should == [photo1, photo2].as_json
    end
  end
end
