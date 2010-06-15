class AddPopulatedColumnToGisRegions < ActiveRecord::Migration
  def self.up
    add_column :gis_regions, :populated, :boolean, :default => false
  end

  def self.down
    remove_column :gis_regions, :populated
  end
end
