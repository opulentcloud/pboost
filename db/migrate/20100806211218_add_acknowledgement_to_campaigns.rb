class AddAcknowledgementToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :acknowledgement, :boolean
  end

  def self.down
    remove_column :campaigns, :acknowledgement
  end
end
