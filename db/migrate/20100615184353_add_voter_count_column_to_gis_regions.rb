class AddVoterCountColumnToGisRegions < ActiveRecord::Migration
  def self.up
    add_column :gis_regions, :voter_count, :integer, :default => 0
  end

  def self.down
    remove_column :gis_regions, :voter_count
  end
end
