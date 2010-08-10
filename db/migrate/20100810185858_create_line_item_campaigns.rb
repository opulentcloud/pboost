require 'migration_helpers'

class CreateLineItemCampaigns < ActiveRecord::Migration
	extend MigrationHelpers

  def self.up
    create_table :line_item_campaigns do |t|
      t.integer :line_item_id, :null => false
			t.integer :campaign_id, :null => false

      t.timestamps
    end
		add_index :line_item_campaigns,[:line_item_id, :campaign_id], :unique => true
    add_index :line_item_campaigns, :line_item_id
    add_index :line_item_campaigns, :campaign_id
add_foreign_key :line_item_campaigns, :line_item_id, :line_items, 'ON DELETE RESTRICT'
add_foreign_key :line_item_campaigns, :campaign_id, :campaigns, 'ON DELETE RESTRICT'

  end

  def self.down
    drop_table :line_item_campaigns
  end
end

