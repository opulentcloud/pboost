require 'migration_helpers'

class CreateConstituentAddresses < ActiveRecord::Migration
	extend MigrationHelpers
	
  def self.up
    create_table :constituent_addresses do |t|
      t.integer :political_campaign_id
      t.integer :address_id

      t.timestamps
    end
		add_index :constituent_addresses, :political_campaign_id
	  add_index :constituent_addresses, :address_id
  	add_index :contituent_addresses, [:political_campaign_id, :address_id], :unique => true
add_foreign_key :constituent_addresses, :political_campaign_id, :political_campaigns, 'ON DELETE RESTRICT'
add_foreign_key :constituent_addresses, :address_id, :addresses, 'ON DELETE RESTRICT'    
  end

  def self.down
    drop_table :constituent_addresses
  end
end
