class AddNotificationPreferences < ActiveRecord::Migration
  def up
    create_table :notification_preferences do |t|
      t.boolean :send_notifications, null: false
      t.string :schedule
      t.integer :user_id
      t.timestamps
    end
  end

  def down
    drop_table :notification_preferences
  end
end
