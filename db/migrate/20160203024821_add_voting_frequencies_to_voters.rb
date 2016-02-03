class AddVotingFrequenciesToVoters < ActiveRecord::Migration
  def change
    add_column :voters, :presidential_primary_voting_frequency, :integer, default: 0
    add_column :voters, :presidential_general_voting_frequency, :integer, default: 0
    add_column :voters, :gubernatorial_primary_voting_frequency, :integer, default: 0
    add_column :voters, :gubernatorial_general_voting_frequency, :integer, default: 0
    add_column :voters, :municipal_primary_voting_frequency, :integer, default: 0
    add_column :voters, :municipal_general_voting_frequency, :integer, default: 0
  end
end
