class CreateParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :participants do |t|
      t.belongs_to :round, null: false
      t.belongs_to :user, null: false
      t.string :participant_type, null: false
      t.boolean :round_starter, null: false, default: false

      t.timestamps null: false
    end
  end
end
