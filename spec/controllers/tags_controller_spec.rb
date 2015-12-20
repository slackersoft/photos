require 'spec_helper'

describe TagsController do
  describe "#show" do
    it "should render with all the photos" do
      mohawk = create(:photo)
      mushroom = create(:photo, name: 'mushroom')
      untagged = create(:photo, name: 'not tagged')

      mohawk.add_tag('foo')
      mushroom.add_tag('foo')

      get :show, tag_name: 'foo'
      expect(response).to be_success
      expect(assigns).to have_key(:photos)
      expect(assigns[:photos]).to eq [untagged, mushroom, mohawk]
    end
  end
end
