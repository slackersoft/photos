class AddHeightsToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :thumb_height, :integer
    add_column :photos, :large_height, :integer
  end
end
