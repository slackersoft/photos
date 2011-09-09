class Photo < ActiveRecord::Base
  has_attached_file :image

  validates_attachment_presence :image
  validates_presence_of :name
end
