require 'migration_helpers'

class CreateGisRegions < ActiveRecord::Migration
	extend MigrationHelpers

  def self.up
    create_table :gis_regions do |t|
      t.string :name, :limit => 128, :null => false
      t.polygon :geom, :srid => 4326, :null => false
			t.references :political_campaign, :null => false

      t.timestamps
    end
		add_index :gis_regions, :geom, :spatial => true
		add_index :gis_regions, :political_campaign_id
		add_index :gis_regions, [:name, :political_campaign_id], :unique => true
	
  end

  def self.down
    drop_table :gis_regions
  end
end
