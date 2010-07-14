class AddColumnGeom2ToGisRegions < ActiveRecord::Migration
  def self.up
		add_column :gis_regions, :geom2, :multi_polygon, :srid => 4326
		add_index :gis_regions, :geom2, :spatial => true
  end

  def self.down
  	remove_column :gis_regions, :geom2
  end
end
