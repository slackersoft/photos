require 'spec_helper'

describe Photo do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_attachment_presence(:image) }
    it { should validate_uniqueness_of(:original_message_id) }
  end

  it "should have a working factory" do
    build(:photo).should be_valid
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
