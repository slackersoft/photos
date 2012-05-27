class Tag < ActiveRecord::Base
  has_and_belongs_to_many :photos

  validates_uniqueness_of :name

  def ==(other)
    if other.is_a?(String)
      name == other
    else
      super
    end
  end

  def self.find_or_create_by_name(tag_name)
    tag = named(tag_name)
    tag = tag.empty? ? Tag.create(name: tag_name) : tag.first
    tag
  end

  def self.named(tag_name)
    where ['tags.name ilike ?', tag_name]
  end
end
