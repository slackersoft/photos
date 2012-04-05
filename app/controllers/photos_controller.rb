class PhotosController < ApplicationController
  respond_to :html

  def show
    @photos = Photo.all
  end
end
