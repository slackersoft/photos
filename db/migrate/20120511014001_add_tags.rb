class AddTags < ActiveRecord::Migration
  def up
    create_table :tags do |t|
      t.string :name
    end

    add_index :tags, :name

    create_table :photos_tags do |join|
      join.integer :photo_id
      join.integer :tag_id
    end

    add_index :photos_tags, :photo_id
    add_index :photos_tags, :tag_id
  end

  def down
    drop_table :photos_tags
    drop_table :tags
  end
end
