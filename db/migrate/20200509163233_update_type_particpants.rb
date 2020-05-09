class UpdateTypeParticpants < ActiveRecord::Migration[5.2]
  def up
    change_column_null :participants, :participant_type, true
  end

  def down
    change_column_null :participants, :participant_type, false
  end
end
