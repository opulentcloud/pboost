require 'migration_helpers'

class CreateGisRegionsVoters < ActiveRecord::Migration
	extend MigrationHelpers
	
  def self.up
    create_table :gis_regions_voters, :id => false do |t|
			t.integer :gis_region_id, :null => false, :primary => true
      t.integer :voter_id, :null => false, :primary => true
      
      t.timestamps
    end
    add_index :gis_regions_voters, [:gis_region_id, :voter_id], :unique => true
    add_index :gis_regions_voters, :gis_region_id
    add_index :gis_regions_voters, :voter_id
add_foreign_key :gis_regions_voters, :gis_region_id, :gis_regions, 'ON DELETE RESTRICT'
add_foreign_key :gis_regions_voters, :voter_id, :voters, 'ON DELETE RESTRICT'

  end

  def self.down
    drop_table :gis_regions_voters
  end
end
