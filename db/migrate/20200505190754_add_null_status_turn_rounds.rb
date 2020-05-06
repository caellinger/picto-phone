class AddNullStatusTurnRounds < ActiveRecord::Migration[5.2]
  def up
    change_column_null :rounds, :status, false
    change_column_null :rounds, :turn, false
  end

  def down
    change_column_null :rounds, :status, true
    change_column_null :rounds, :turn, true
  end
end
