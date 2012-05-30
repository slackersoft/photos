class RequireEmailForUsers < ActiveRecord::Migration
  def up
    change_column :users, :email, :string, :null => false
  end

  def down
  end
end
