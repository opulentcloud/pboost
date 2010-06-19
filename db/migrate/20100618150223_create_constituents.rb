require 'migration_helpers'

class CreateConstituents < ActiveRecord::Migration
	extend MigrationHelpers
	
  def self.up
    create_table :constituents do |t|
      t.integer :political_campaign_id, :null => false
      t.integer :voter_id, :null => false

      t.timestamps
    end
    add_index :constituents, :political_campaign_id
    add_index :constituents, :voter_id
    add_index :constituents, [:political_campaign_id, :voter_id], :unique => true
add_foreign_key :constituents, :political_campaign_id, :political_campaigns, 'ON DELETE RESTRICT'
add_foreign_key :constituents, :voter_id, :voters, 'ON DELETE RESTRICT'
  end

  def self.down
    drop_table :constituents
  end
end
