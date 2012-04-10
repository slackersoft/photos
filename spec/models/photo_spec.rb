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

  it "should save widths and heights for non-original versions" do
    photo = Photo.create(name: 'foo', image: File.new(Rails.root.join('spec/fixtures/files/mushroom.png')))
    photo.thumb_width.should == 100
    photo.thumb_height.should == 100
    photo.large_width.should == 200
    photo.large_height.should == 200
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
        thumbHeight: photo.thumb_height,
        largeUrl: photo.image.url(:large),
        largeWidth: photo.large_width,
        largeHeight: photo.large_height,
        rawUrl: photo.image.url(:original)
      }
    end
  end

  context "scopes" do
    describe ".for_display" do
      subject { Photo.for_display }

      it { should == [photos(:mushroom), photos(:mohawk)] }
    end
  end

  describe ".reset_dimensions!" do
    let(:photo) { photos(:mushroom) }

    before do
      photo.update_attributes(thumb_width: 0, thumb_height: 0, large_width: 0, large_height: 0)
    end

    it "should reset the saved dimensions to what is currently in the file" do
      photo.reset_dimensions!

      photo.thumb_width.should == 100
      photo.thumb_height.should == 100
      photo.large_width.should == 200
      photo.large_height.should == 200
    end
  end
end
