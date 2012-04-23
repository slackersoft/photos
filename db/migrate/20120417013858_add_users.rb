class AddUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :email
    end

    add_index :users, :email
  end

  def down
    drop_table :users
  end
end
