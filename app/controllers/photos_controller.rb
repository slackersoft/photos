class PhotosController < ApplicationController
  respond_to :html

  def show
    @photos = Photo.for_display
  end
end
