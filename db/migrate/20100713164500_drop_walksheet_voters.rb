require 'migration_helpers'

class DropWalksheetVoters < ActiveRecord::Migration
	extend MigrationHelpers
	
  def self.up
  	drop_table :walksheet_voters
  end

  def self.down
    create_table :walksheet_voters do |t|
      t.integer :walksheet_id
      t.integer :voter_id

      t.timestamps
    end
		add_index :walksheet_voters, :walksheet_id
	  add_index :walksheet_voters, :voter_id
  	add_index :walksheet_voters, [:walksheet_id, :voter_id], :unique => true
add_foreign_key :walksheet_voters, :walksheet_id, :walksheets, 'ON DELETE RESTRICT'
add_foreign_key :walksheet_voters, :voter_id, :voters, 'ON DELETE RESTRICT'    
  end
end
