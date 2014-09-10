require 'spec_helper'

describe DimensionUpdater do
  before do
    allow(DimensionUpdater).to receive(:log)
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
      expect(mushroom.thumb_width).to eq 100
      expect(mushroom.thumb_height).to eq 100
      expect(mushroom.large_width).to eq 200
      expect(mushroom.large_height).to eq 200

      mohawk.reload
      expect(mohawk.thumb_width).to eq 75
      expect(mohawk.thumb_height).to eq 100
      expect(mohawk.large_width).to eq 375
      expect(mohawk.large_height).to eq 500
    end
  end
end
