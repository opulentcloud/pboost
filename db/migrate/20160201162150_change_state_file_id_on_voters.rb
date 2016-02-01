class ChangeStateFileIdOnVoters < ActiveRecord::Migration
  def change
    change_column :voters, :state_file_id, 'integer USING CAST(state_file_id AS integer)'
    change_column_null :voters, :state_file_id, false
  end
end
