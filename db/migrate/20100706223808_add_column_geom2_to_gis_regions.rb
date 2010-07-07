class AddColumnGeom2ToGisRegions < ActiveRecord::Migration
  def self.up
		add_column :gis_regions, :geom2, :multi_polygon, :srid => 4326
  end

  def self.down
  	remove_column :gis_regions, :geom2
  end
end
