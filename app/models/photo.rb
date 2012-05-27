class Photo < ActiveRecord::Base
  has_attached_file :image, ::PAPERCLIP_OPTIONS

  has_and_belongs_to_many :tags

  after_post_process :save_dimensions

  validates_attachment_presence :image
  validates_presence_of :name
  validates_uniqueness_of :original_message_id

  before_save :uniq_tags

  def self.for_display
    order('id desc')
  end

  def as_json(options={ })
    {
      id: id,
      name: name,
      description: description,
      thumbUrl: image.url(:thumb),
      thumbWidth: thumb_width,
      thumbHeight: thumb_height,
      largeUrl: image.url(:large),
      largeWidth: large_width,
      largeHeight: large_height,
      rawUrl: image.url(:original),
      tags: tag_names
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

  def has_tag?(tag_name)
    tag_names.map(&:downcase).include? tag_name.downcase
  end

  def add_tag(tag_name)
    unless has_tag?(tag_name)
      self.tags << Tag.find_or_create_by_name(tag_name)
      save
    end
  end

  def remove_tag(tag_name)
    self.tags.delete(Tag.named(tag_name))
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

  def uniq_tags
    self.tags.uniq!
  end

  def tag_names
    tags.map(&:name)
  end
end
