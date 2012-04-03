class Photo < ActiveRecord::Base
  has_attached_file :image, ::PAPERCLIP_OPTIONS

  validates_attachment_presence :image
  validates_presence_of :name

  def as_json(options={})
    {
      id: id,
      name: name,
      thumbUrl: image.url(:thumb),
      largeUrl: image.url(:large),
      rawUrl: image.url(:original)
    }
  end
end
