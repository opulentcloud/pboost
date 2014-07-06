class CreateVotingHistories < ActiveRecord::Migration
  def change
    create_table :voting_histories do |t|
      t.integer :election_year
      t.integer :election_month
      t.string :election_type, limit: 2
      t.string :voter_type, limit: 1
      
      t.timestamps
    end
    add_reference :voting_histories, :voter, index: true
  end
end
