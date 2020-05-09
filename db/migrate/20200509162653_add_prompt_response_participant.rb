class AddPromptResponseParticipant < ActiveRecord::Migration[5.2]
  def up
    add_column :participants, :prompt, :string
    add_column :participants, :response, :string
  end

  def down
    remove_column :participants, :prompt
    remove_column :participants, :response
  end
end
