require "spec_helper"

describe PhotosController do
  describe "#show" do
    it "should render with all the photos" do
      get :show, id: 'foo'
      expect(response).to be_success
      expect(assigns).to have_key(:photos)
      expect(assigns[:photos]).to eq [photos(:mushroom), photos(:mohawk)]
    end
  end

  describe "#delete" do
    let!(:photo) { create(:photo) }
    subject { xhr :delete, :destroy, id: photo.id }

    context "when signed in as an admin user" do
      before do
        sign_in users(:admin)
      end

      it "should delete the photo" do
        expect { subject }.to change { Photo.count }.by(-1)
        expect(response).to be_success
      end
    end

    context "when signed in as a non-admin user" do
      before do
        sign_in users(:authorized)
      end

      it "should not delete the photo and return unauthorized" do
        expect { subject }.not_to change { Photo.count }
        expect(response.code).to eq '403'
      end
    end

    context "when not signed in" do
      before do
        sign_out :user
      end

      it "should not delete the photo and return unauthorized" do
        expect { subject }.not_to change { Photo.count }
        expect(response.code).to eq '403'
      end
    end
  end

  describe "#add_tag" do
    let(:photo) { photos(:mohawk) }
    let(:tag) { 'hi' }

    subject { xhr :post, :add_tag, id: photo.id, tag: tag }

    context "when signed in as an authorized user" do
      before do
        sign_in users(:authorized)
      end

      it "should add the tag" do
        expect { subject }.to change { photo.reload.tags.size }.by(1)
        expect(response).to be_success
        expect(photo.tags.last).to eq 'hi'
      end

      it "should render the updated photo as json" do
        subject
        expect(response).to be_success
        photo_json = JSON.parse(response.body)
        expect(photo_json['tags']).to eq %w(hi)
      end
    end

    context "when signed in as an unauthorized user" do
      before do
        sign_in users(:unauthorized)
      end

      it "should not add the tag and fail with unauthorized" do
        expect { subject }.not_to change { photo.reload.tags.size }
        expect(response.code).to eq '403'
      end
    end

    context "when not signed in" do
      before do
        sign_out :user
      end

      it "should not add the tag and fail with unauthorized" do
        expect { subject }.not_to change { photo.reload.tags.size }
        expect(response.code).to eq '403'
      end
    end
  end

  describe "#remove_tag" do
    let(:photo) { photos(:mushroom) }
    let(:tag) { tags(:tag).name }

    subject { xhr :post, :remove_tag, id: photo.id, tag: tag }

    describe "when signed in as an authorized user" do
      before do
        sign_in users(:authorized)
      end

      it "should remove the tag" do
        expect { subject }.to change { photo.reload.tags.size }.by(-1)
        expect(response).to be_success
        expect(photo.tags).to eq []
      end

      it "should render the updated photo as json" do
        subject
        expect(response).to be_success
        photo_json = JSON.parse(response.body)
        expect(photo_json['tags']).to eq []
      end
    end

    context "when signed in as an unauthorized user" do
      before do
        sign_in users(:unauthorized)
      end

      it "should not add the tag and fail with unauthorized" do
        expect { subject }.not_to change { photo.reload.tags.size }
        expect(response.code).to eq '403'
      end
    end

    context "when not signed in" do
      before do
        sign_out :user
      end

      it "should not add the tag and fail with unauthorized" do
        expect { subject }.not_to change { photo.reload.tags.size }
        expect(response.code).to eq '403'
      end
    end
  end
end
