class CreateRegisteredVoterHistories < ActiveRecord::Migration
  def change
    create_table :registered_voter_histories do |t|
      t.integer :vtrid, null: false, index: true
      t.string :election_date
      t.string :election_description
      t.string :election_type
      t.string :political_party
      t.string :election_code
      t.string :voting_method
      t.string :date_of_voting
      t.string :precinct
      t.string :early_voting_location
      t.string :juristiction_code
      t.string :county_name

      t.timestamps
    end
  end
end

