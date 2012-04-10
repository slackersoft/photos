class Photo < ActiveRecord::Base
  has_attached_file :image, ::PAPERCLIP_OPTIONS

  after_post_process :save_dimensions

  validates_attachment_presence :image
  validates_presence_of :name
  validates_uniqueness_of :original_message_id

  def self.for_display
    order('id desc')
  end

  def as_json(options={ })
    {
      id: id,
      name: name,
      thumbUrl: image.url(:thumb),
      thumbWidth: thumb_width,
      thumbHeight: thumb_height,
      largeUrl: image.url(:large),
      largeWidth: large_width,
      largeHeight: large_height,
      rawUrl: image.url(:original)
    }
  end

  def reset_dimensions!
    converted_styles.each do |style|
      geo = Paperclip::Geometry.from_file(image.to_file(style))
      send("#{style}_width=", geo.width)
      send("#{style}_height=", geo.height)
    end
    save!
  end

  private

  def save_dimensions
    converted_styles.each do |style|
      geo = Paperclip::Geometry.from_file(image.queued_for_write[style])
      send("#{style}_width=", geo.width)
      send("#{style}_height=", geo.height)
    end
  end

  def converted_styles
    ::PAPERCLIP_OPTIONS[:styles].keys.reject { |s| s == :original }
  end
end
