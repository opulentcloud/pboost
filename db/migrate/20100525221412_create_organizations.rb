require 'migration_helpers'

class CreateOrganizations < ActiveRecord::Migration
	extend MigrationHelpers
	
  def self.up
    create_table :organizations do |t|
      t.references :organization_type
      t.string :name, :limit => 100, :null => false
      t.string :email, :limit => 125
      t.string :phone, :limit => 10
      t.string :fax, :limit => 10
      t.string :website, :limit => 150
      t.references :account_type
			t.boolean :enabled, :default => false

      t.timestamps
    end
add_foreign_key :organizations, :organization_type_id, :organization_types, 'ON DELETE RESTRICT'
add_foreign_key :organizations, :account_type_id, :account_types, 'ON DELETE RESTRICT'    
  end

  def self.down
    drop_table :organizations
  end
end
