class AddCurrentPromptRounds < ActiveRecord::Migration[5.2]
  def up
    add_column :rounds, :current_prompt, :string
  end

  def down
    remove_column :rounds, :current_prompt, :string
  end
end
