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

  it "should save widths for non-original versions" do
    photo = Photo.create(name: 'foo', image: File.new(Rails.root.join('spec/fixtures/files/mushroom.png')))
    photo.thumb_width.should == 100
    photo.large_width.should == 200
  end

  describe "#as_json" do
    let(:photo) { Photo.create(name: 'foo', image: File.new(Rails.root.join('spec/fixtures/files/mushroom.png'))) }
    subject { photo.as_json }

    it do
      should == {
        id: photo.id,
        name: 'foo',
        thumbUrl: photo.image.url(:thumb),
        thumbWidth: photo.thumb_width,
        largeUrl: photo.image.url(:large),
        largeWidth: photo.large_width,
        rawUrl: photo.image.url(:original)
      }
    end
  end
end
