class PhotosController < ApplicationController
  def show
    @photos = Photo.for_display
  end

  def add_tag
    if current_user && current_user.authorized
      photo = Photo.find(params[:id])
      photo.add_tag params[:tag]

      render json: photo
    else
      head 403
    end
  end

  def remove_tag
    if current_user && current_user.authorized
      photo = Photo.find(params[:id])
      photo.remove_tag params[:tag]

      render json: photo
    else
      head 403
    end
  end
end
