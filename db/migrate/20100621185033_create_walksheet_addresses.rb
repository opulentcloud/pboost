require 'migration_helpers'

class CreateWalksheetAddresses < ActiveRecord::Migration
	extend MigrationHelpers
	
  def self.up
    create_table :walksheet_addresses do |t|
      t.integer :walksheet_id
      t.integer :address_id

      t.timestamps
    end
		add_index :walksheet_addresses, :walksheet_id
	  add_index :walksheet_addresses, :address_id
  	add_index :walksheet_addresses, [:walksheet_id, :address_id], :unique => true
add_foreign_key :walksheet_addresses, :walksheet_id, :walksheets, 'ON DELETE RESTRICT'
add_foreign_key :walksheet_addresses, :address_id, :addresses, 'ON DELETE RESTRICT'    
  end

  def self.down
    drop_table :walksheet_addresses
  end
end
