class CreateSenderEmails < ActiveRecord::Migration
  def up
    create_table :sender_emails do |t|
      t.integer :user_id
      t.string :address
    end

    add_index :sender_emails, :user_id
  end

  def down
    drop_table :sender_emails
  end
end
