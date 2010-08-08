class AddPopulatedToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :populated, :boolean
  end

  def self.down
    remove_column :campaigns, :populated
  end
end
