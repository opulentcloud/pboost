class AddCountyNameIndexToAddresses < ActiveRecord::Migration
  def self.up
  	add_index :addresses, :county_name
  end

  def self.down
  	remove_index :addresses, :county_name
  end
end
