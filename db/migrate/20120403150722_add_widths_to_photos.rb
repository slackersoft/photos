class AddWidthsToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :thumb_width, :integer
    add_column :photos, :large_width, :integer
  end
end
