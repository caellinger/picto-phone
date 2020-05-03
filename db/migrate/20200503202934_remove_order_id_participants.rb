class RemoveOrderIdParticipants < ActiveRecord::Migration[5.2]
  def up
    remove_column :participants, :order_id
  end

  def down
    add_column :participants, :order_id, :integer
  end
end
