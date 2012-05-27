require 'spec_helper'

describe Tag do
  describe "associations" do
    it { should have_and_belong_to_many(:photos) }
  end

  describe "validations" do
    it { should validate_uniqueness_of(:name) }
  end

  describe "#==" do
    let(:tag) { Tag.new(name: 'foo') }

    context "when the other argument is a tag object" do
      it "should compare correctly" do
        tag.should == tag
      end
    end

    context "when the other argument is a string" do
      it "should compare the string with its name" do
        tag.should == 'foo'
      end
    end
  end

  describe ".find_or_create_by_name" do
    let(:tag_name) { 'hello' }
    subject { Tag.find_or_create_by_name(tag_name) }

    context "when the tag doesn't exist" do
      it "should create the tag" do
        lambda { subject }.should change { Tag.count }.by(1)
      end

      it "should return the created tag" do
        subject.should == tag_name
      end
    end

    context "when the tag exists" do
      before do
        Tag.create! name: existing_tag_name
      end
      let(:existing_tag_name) { tag_name }

      it "should not create a tag" do
        lambda { subject }.should_not change { Tag.count }
      end

      it "should return the existing tag" do
        subject.should == tag_name
      end

      context "when the existing tag is a different case" do
        let(:existing_tag_name) { tag_name.upcase }

        it "should not create a tag" do
          lambda { subject }.should_not change { Tag.count }
        end
      end
    end
  end

  describe ".named" do
    let(:tag_name) { 'hello' }
    subject { Tag.named(tag_name) }

    context "when the tag doesn't exist" do
      it "should return nothing" do
        subject.should be_empty
      end
    end

    context "when the tag exists" do
      before do
        Tag.create! name: existing_tag_name
      end
      let(:existing_tag_name) { tag_name }

      it "should return the existing tag" do
        subject.should == [tag_name]
      end

      context "when the existing tag is a different case" do
        let(:existing_tag_name) { tag_name.upcase }

        it "should return the existing tag" do
          subject.should == [existing_tag_name]
        end
      end
    end
  end
end
