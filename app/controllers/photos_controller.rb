class PhotosController < ApplicationController
  def show
    @photos = Photo.for_display
  end

  def add_tag
    photo = Photo.find(params[:id])
    photo.add_tag params[:tag]

    render json: photo
  end
end
