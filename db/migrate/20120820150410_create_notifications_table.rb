class CreateNotificationsTable < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :subject_id, null: false
      t.string :subject_type, null: false
      t.integer :notification_preference_id
      t.timestamp :sent_at
      t.timestamps
    end
  end
end
