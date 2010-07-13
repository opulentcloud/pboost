require 'migration_helpers'

class CreateContactListAddresses < ActiveRecord::Migration
	extend MigrationHelpers
	
  def self.up
    create_table :contact_list_addresses do |t|
      t.integer :contact_list_id
      t.integer :address_id

      t.timestamps
    end
		add_index :contact_list_addresses, :contact_list_id
	  add_index :contact_list_addresses, :address_id
  	add_index :contact_list_addresses, [:contact_list_id, :address_id], :unique => true
  end

  def self.down
    drop_table :contact_list_addresses
  end
end
