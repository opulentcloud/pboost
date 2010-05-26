require 'migration_helpers'

class CreateUsers < ActiveRecord::Migration
	extend MigrationHelpers

  def self.up
    create_table :users do |t|
    	t.string :login, :null => false, :limit => 100
      t.string :email, :null => false, :limit => 100
      t.string :first_name, :null => false, :limit => 32
      t.string :last_name, :null => false, :limit => 32
      t.string :phone, :limit => 10
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token, :null => false
      t.string :perishable_token, :null => false
      t.boolean :active, :default => false, :null => false
      
      #These fields are automatically maintained by AuthLogic
      t.integer :login_count, :null => false, :default => 0
      t.integer :failed_login_count, :null => false, :default => 0
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip

			#these fields our for our application
			t.references :time_zone
			t.references :organization

      t.timestamps
    end
		add_index :users, :login, :unique => true
		add_index :users, :email, :unique => true
		add_index :users, :perishable_token, :unique => true
		add_index :users, :organization_id
    add_foreign_key :users, :time_zone_id, :time_zones, 'ON DELETE RESTRICT'
		add_foreign_key :users, :organization_id, :organizations, 'ON DELETE RESTRICT'
  end

  def self.down
    drop_table :users
  end
end

