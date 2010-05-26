require 'migration_helpers'

class CreateRolesUsers < ActiveRecord::Migration
	extend MigrationHelpers
	
  def self.up
  	create_table :roles_users, :id => false do |t|
  		t.integer :role_id, :null => false, :primary => true
  		t.integer :user_id, :null => false, :primary => true
  		
  		t.timestamps
  	end
  	add_index :roles_users, :role_id
  	add_index :roles_users, :user_id
    add_foreign_key :roles_users, :role_id, :roles, 'ON DELETE CASCADE'
    add_foreign_key :roles_users, :user_id, :users, 'ON DELETE CASCADE'
  end

  def self.down
		drop_table :roles_users
  end
end

