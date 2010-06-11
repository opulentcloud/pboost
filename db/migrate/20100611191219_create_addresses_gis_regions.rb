require 'migration_helpers'

class CreateAddressesGisRegions < ActiveRecord::Migration
	extend MigrationHelpers

  def self.up
    create_table :addresses_gis_regions, :id => false do |t|
      t.integer :address_id, :null => false, :primary => true
			t.integer :gis_region_id, :null => false, :primary => true

      t.timestamps
    end
    add_index :addresses_gis_regions, :address_id
    add_index :addresses_gis_regions, :gis_region_id
add_foreign_key :addresses_gis_regions, :address_id, :addresses, 'ON DELETE CASCADE'
add_foreign_key :addresses_gis_regions, :gis_region_id, :gis_regions, 'ON DELETE CASCADE'

  end

  def self.down
    drop_table :addresses_gis_regions
  end
end

