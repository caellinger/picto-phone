class AddStatusTurnRounds < ActiveRecord::Migration[5.2]
  def change
    add_column :rounds, :status, :string, default: "waiting"
    add_column :rounds, :turn, :integer, default: 0
  end
end
