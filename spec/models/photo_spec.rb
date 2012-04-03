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

  describe "#as_json" do
    let(:photo) { Photo.create(name: 'foo', image: File.new(Rails.root.join('spec/fixtures/files/mushroom.png'))) }
    subject { photo.as_json }

    it do
      should == {
        id: photo.id,
        name: 'foo',
        thumbUrl: photo.image.url(:thumb),
        largeUrl: photo.image.url(:large),
        rawUrl: photo.image.url(:original)
      }
    end
  end
end
