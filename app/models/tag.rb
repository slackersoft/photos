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
end
