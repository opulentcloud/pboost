class CreateVotingHistoryVoters < ActiveRecord::Migration
  def self.up
	  create_table :voting_history_voters do |t|
			t.integer :election_year
			t.integer :election_month
			t.string :election_type, :limit => 2 # G-General, MG-Muni General, MP-Muni Primary, P-Primary
			t.string :voter_type, :limit => 1
			t.references :voter

			t.timestamps			
		end
		add_index :voting_history_voters, :voter_id
  end

  def self.down
  	drop table :voting_history_voters
  end
end
