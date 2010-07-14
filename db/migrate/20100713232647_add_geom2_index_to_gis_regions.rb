class AddGeom2IndexToGisRegions < ActiveRecord::Migration
  def self.up
		add_index :gis_regions, :geom2, :spatial => true
  end

  def self.down
  	remove_index :gis_regions, :geom2
  end
end
