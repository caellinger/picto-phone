class UpdatePromptRounds < ActiveRecord::Migration[5.2]
  def up
    rename_column :rounds, :prompt, :round_prompt
  end

  def down
    rename_column :rounds, :round_prompt, :prompt
  end
end
