class AddColumnTurnUserIdRounds < ActiveRecord::Migration[5.2]
  def up
    add_column :rounds, :turn_user_id, :integer, null: false
  end

  def down
    remove_column :rounds, :turn_user_id
  end
end
