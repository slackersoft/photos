require 'spec_helper'

describe Photo do
  describe "validations" do
    it "should require an image" do
      photo = Photo.new
      photo.should_not be_valid
      photo.should have_attached_file(:image)
      photo.should have(1).error_on(:image_file_name)
    end

    it "should require a name" do
      photo = Photo.new
      photo.should_not be_valid
      photo.should have(1).error_on(:name)
    end
  end
end
