require 'migration_helpers'

class CreateContactListVoters < ActiveRecord::Migration
	extend MigrationHelpers
	
  def self.up
    create_table :contact_list_voters do |t|
      t.integer :contact_list_id
      t.integer :voter_id

      t.timestamps
    end
		add_index :contact_list_voters, :contact_list_id
	  add_index :contact_list_voters, :voter_id
  	add_index :contact_list_voters, [:contact_list_id, :voter_id], :unique => true
  end

  def self.down
    drop_table :contact_list_voters
  end
end
