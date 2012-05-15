require 'spec_helper'

describe Photo do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_attachment_presence(:image) }
    it { should validate_uniqueness_of(:original_message_id) }
  end

  describe "associations" do
    it { should have_and_belong_to_many(:tags) }
  end

  it "should have a working factory" do
    build(:photo).should be_valid
  end

  it "should save widths and heights for non-original versions" do
    photo = Photo.new(name: 'foo', image: File.new(Rails.root.join('spec/fixtures/files/mushroom.png')))
    photo.thumb_width.should == 100
    photo.thumb_height.should == 100
    photo.large_width.should == 200
    photo.large_height.should == 200
  end

  describe "#as_json" do
    let(:tag1) { Tag.new(name: 'hi') }
    let(:tag2) { Tag.new(name: 'bye') }
    let(:photo) { Photo.new(name: 'foo', description: 'and stuff', image: File.new(Rails.root.join('spec/fixtures/files/mushroom.png')), tags: [tag1, tag2]) }
    subject { photo.as_json }

    it do
      should == {
        id: photo.id,
        name: 'foo',
        description: 'and stuff',
        thumbUrl: photo.image.url(:thumb),
        thumbWidth: photo.thumb_width,
        thumbHeight: photo.thumb_height,
        largeUrl: photo.image.url(:large),
        largeWidth: photo.large_width,
        largeHeight: photo.large_height,
        rawUrl: photo.image.url(:original),
        tags: %w(hi bye)
      }
    end
  end

  context "scopes" do
    describe ".for_display" do
      subject { Photo.for_display }

      it { should == [photos(:mushroom), photos(:mohawk)] }
    end
  end

  describe "#reset_dimensions!" do
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

  describe "#has_tag?" do
    let(:photo) { photos(:mohawk) }
    let(:tag) { 'hello' }

    subject { photo.has_tag?(tag) }

    context "when the photo has no tags" do
      it { should == false }
    end

    context "when the photo has other tags" do
      before do
        photo.add_tag 'foo'
      end

      it { should == false }
    end

    context "when the photo has the specified tag" do
      before do
        photo.add_tag tag
      end

      it { should == true }
    end
  end

  describe "#add_tag" do
    let(:photo) { photos(:mohawk) }
    let(:tag) { 'hello' }

    before do
      photo.add_tag tag
    end

    it "should add the tag" do
      photo.tags.map(&:name).should == %w(hello)
    end

    context "when the tag already exists in the database" do
      let(:tag) { Tag.create(name: 'hello').name }

      it "should not create another tag model" do
        subject
        Tag.count.should == 1
      end
    end

    context "when the photo is already associated with that tag" do
      it "should not add a duplicate entry" do
        lambda { photo.add_tag tag }.should_not change { photo.reload.tags.count }
      end
    end
  end
end
