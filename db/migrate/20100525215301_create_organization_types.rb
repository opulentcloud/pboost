class CreateOrganizationTypes < ActiveRecord::Migration
  def self.up
    create_table :organization_types do |t|
      t.string :name, :limit => 100, :null => false

      t.timestamps
    end
		add_index :organization_types, :name, :unique => true    
  end

  def self.down
    drop_table :organization_types
  end
end
