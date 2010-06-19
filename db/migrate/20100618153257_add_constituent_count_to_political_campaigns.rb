class AddConstituentCountToPoliticalCampaigns < ActiveRecord::Migration
  def self.up
    add_column :political_campaigns, :constituent_count, :integer, :default => 0
  end

  def self.down
    remove_column :political_campaigns, :constituent_count
  end
end
