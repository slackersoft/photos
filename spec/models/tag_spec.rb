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
end
