class CreateDrawers < ActiveRecord::Migration[5.2]
  def change
    create_table :drawers do |t|
      t.belongs_to :participant, null: false
      t.string :prompt
      t.string :drawing_location

      t.timestamps null: false
    end
  end
end
