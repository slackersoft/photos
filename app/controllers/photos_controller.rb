class PhotosController < ApplicationController
  respond_to :json

  def index
    respond_with Photo.all
  end
end
