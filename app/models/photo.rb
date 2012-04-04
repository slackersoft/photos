class Photo < ActiveRecord::Base
  has_attached_file :image, ::PAPERCLIP_OPTIONS

  after_post_process :save_dimensions

  validates_attachment_presence :image
  validates_presence_of :name

  def as_json(options={})
    {
      id: id,
      name: name,
      thumbUrl: image.url(:thumb),
      thumbWidth: thumb_width,
      largeUrl: image.url(:large),
      largeWidth: large_width,
      rawUrl: image.url(:original)
    }
  end

  private

  def save_dimensions
    thumb_geo = Paperclip::Geometry.from_file(image.queued_for_write[:thumb])
    large_geo = Paperclip::Geometry.from_file(image.queued_for_write[:large])
    self.thumb_width = thumb_geo.width
    self.large_width = large_geo.width
  end
end
