class AddVoterCountToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :voter_count, :integer
  end

  def self.down
    remove_column :campaigns, :voter_count
  end
end
