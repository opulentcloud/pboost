class CreateRegisteredVotersHistoryUpdates < ActiveRecord::Migration
  def change
    create_table :registered_voters_history_updates do |t|
      t.integer :state_file_id
      t.string :voter_type
      t.integer :election_year
      t.integer :election_month
      t.string :election_type

      t.timestamps
    end
    add_index :registered_voters_history_updates, :state_file_id
  end
end
