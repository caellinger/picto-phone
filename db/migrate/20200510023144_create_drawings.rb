class CreateDrawings < ActiveRecord::Migration[5.2]
  def change
    create_table :drawings do |t|
      t.belongs_to :participant, null: false
      t.text :drawing, null: false

      t.timestamps null: false
    end
  end
end
