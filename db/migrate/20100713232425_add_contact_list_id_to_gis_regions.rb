class AddContactListIdToGisRegions < ActiveRecord::Migration
  def self.up
  	add_column :gis_regions, :contact_list_id, :integer
  	add_index :gis_regions, :contact_list_id
  end

  def self.down
  	remove_column :gis_regions, :contact_list_id
  end
end
