class AddAuthorizedAndAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :authorized, :boolean
    add_column :users, :admin, :boolean
  end
end
