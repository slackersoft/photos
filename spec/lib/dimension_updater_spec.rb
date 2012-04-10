require 'spec_helper'

describe DimensionUpdater do
  before do
    DimensionUpdater.stub(:log)
  end

  describe ".update_dimensions" do
    let(:mohawk) { photos(:mohawk) }
    let(:mushroom) { photos(:mushroom) }

    before do
      reset_dimensions = {thumb_width: 0, thumb_height: 0, large_width: 0, large_height: 0}
      mohawk.update_attributes reset_dimensions
      mushroom.update_attributes reset_dimensions
    end

    it "should update the dimensions of all photos" do
      DimensionUpdater.update_dimensions

      mushroom.reload
      mushroom.thumb_width.should == 100
      mushroom.thumb_height.should == 100
      mushroom.large_width.should == 200
      mushroom.large_height.should == 200

      mohawk.reload
      mohawk.thumb_width.should == 75
      mohawk.thumb_height.should == 100
      mohawk.large_width.should == 375
      mohawk.large_height.should == 500
    end
  end
end
