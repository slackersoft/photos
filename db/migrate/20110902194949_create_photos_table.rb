class CreatePhotosTable < ActiveRecord::Migration
  def up
    create_table :photos do |t|
      t.string :name
      t.string :description
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.timestamps
    end
  end

  def down
    drop_table :photos
  end
end
