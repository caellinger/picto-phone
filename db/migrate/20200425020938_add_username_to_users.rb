class AddUsernameToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :user_name, :string, null: false
    add_index :users, :user_name, unique: true
  end

  def down
    remove_column :users, :user_name
    remove_index :users, :user_name
  end
end
