class AddMunicipalDistrictIdToPrecincts < ActiveRecord::Migration
  def self.up
    add_column :precincts, :municipal_district_id, :integer
    add_index :precincts, :municipal_district_id
    add_index :precincts, [:municipal_district_id, :code], :unique => true
  end

  def self.down
    remove_column :precincts, :municipal_district_id
  end
end
