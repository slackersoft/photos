class RootsController < ApplicationController
  respond_to :html

  def index
    @photos = Photo.for_display
  end
end
