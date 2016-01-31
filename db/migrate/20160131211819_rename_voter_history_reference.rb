class RenameVoterHistoryReference < ActiveRecord::Migration
  def self.up
    remove_reference :voting_histories, :voter
    add_column :voting_histories, :state_file_id, :string, limit: 10
    add_index :voting_histories, :state_file_id
  end

  def self.down
    add_reference :voting_histories, :voter, index: true
    remove_index :voting_histories, :state_file_id
    remove_column :voting_histories, :state_file_id
  end
end
