class AddIndexesToVotingHistories < ActiveRecord::Migration
  def change
    add_index :voting_histories, :election_type
    add_index :voting_histories, :election_year
  end
end
