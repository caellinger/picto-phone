class CreateRounds < ActiveRecord::Migration[5.2]
  def change
    create_table :rounds do |t|
      t.string :starter_name, null: false
      t.string :prompt

      t.timestamps null: false
    end
  end
end
