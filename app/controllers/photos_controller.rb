class PhotosController < ApplicationController
  def show
    @photos = Photo.for_display
  end

  def destroy
    if current_user && current_user.admin
      Photo.where(id: params[:id]).destroy_all
      head :ok
    else
      head 403
    end
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
