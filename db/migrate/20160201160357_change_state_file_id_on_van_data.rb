class ChangeStateFileIdOnVanData < ActiveRecord::Migration
  def change
    change_column :van_data, :state_file_id, 'integer USING CAST(state_file_id AS integer)'
    change_column_null :van_data, :state_file_id, false
    change_column :van_data, :vote_builder_id, 'integer USING CAST(vote_builder_id AS integer)'
    change_column_null :van_data, :vote_builder_id, false
    add_index :van_data, :state_file_id
    add_index :van_data, :vote_builder_id
  end
end
