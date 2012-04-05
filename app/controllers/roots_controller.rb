class RootsController < ApplicationController
  respond_to :html

  def index
    @photos = Photo.all
  end
end
