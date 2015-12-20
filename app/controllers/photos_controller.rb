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

  def new
    unless current_user && current_user.admin?
      redirect_to root_path
    end
  end

  def create
    unless current_user && current_user.admin?
      redirect_to root_path and return
    end

    photo = current_user.photos.create(photo_params)
    redirect_to new_photo_path, alert: photo.valid? ? 'Saved' : "Oops: #{photo.errors.full_messages}"
  end

  def edit
    unless current_user && current_user.admin?
      redirect_to root_path and return
    end

    @photo = Photo.find(params[:id])
  end

  def update
    unless current_user && current_user.admin?
      redirect_to root_path and return
    end

    photo = Photo.find(params[:id])
    photo.update(photo_params)

    redirect_to root_path
  end

  private

  def photo_params
    params.require(:photo).permit(:name, :image, :created_at)
  end
end
