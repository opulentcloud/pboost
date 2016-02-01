class RenameVoterHistoryReference < ActiveRecord::Migration
  def self.up
    remove_reference :voting_histories, :voter
    add_column :voting_histories, :state_file_id, :integer, null: false
    add_index :voting_histories, :state_file_id
    add_index :voting_histories, [:state_file_id, :election_type, :election_year], name: :uniq_voting_histories_idx, unique: true
  end

  def self.down
    add_reference :voting_histories, :voter, index: true
    remove_index :voting_histories, name: :uniq_voting_histories_idx
    remove_index :voting_histories, :state_file_id
    remove_column :voting_histories, :state_file_id
  end
end
