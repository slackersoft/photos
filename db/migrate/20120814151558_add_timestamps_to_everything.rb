class AddTimestampsToEverything < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.timestamps
    end

    change_table :sender_emails do |t|
      t.timestamps
    end

    change_table :tags do |t|
      t.timestamps
    end

    change_table :photos_tags do |t|
      t.timestamps
    end
  end

  def down
    change_table :users do |t|
      t.remove :created_at
      t.remove :updated_at
    end

    change_table :sender_emails do |t|
      t.remove :created_at
      t.remove :updated_at
    end

    change_table :tags do |t|
      t.remove :created_at
      t.remove :updated_at
    end

    change_table :photos_tags do |t|
      t.remove :created_at
      t.remove :updated_at
    end
  end
end
