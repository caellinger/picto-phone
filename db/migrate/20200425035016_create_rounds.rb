class CreateRounds < ActiveRecord::Migration[5.2]
  def change
    create_table :rounds do |t|
      t.belongs_to :user, null: false
      t.string :prompt
      t.text :image
    end
  end
end
