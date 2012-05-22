class TagsController < ApplicationController
  def show
    @photos = Photo.for_display
  end
end
