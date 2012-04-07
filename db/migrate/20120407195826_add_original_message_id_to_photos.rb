class AddOriginalMessageIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :original_message_id, :string
  end
end
