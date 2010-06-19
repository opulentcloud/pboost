class AddPopulatedToPoliticalCampaigns < ActiveRecord::Migration
  def self.up
    add_column :political_campaigns, :populated, :boolean, :default => false
  end

  def self.down
    remove_column :political_campaigns, :populated
  end
end
