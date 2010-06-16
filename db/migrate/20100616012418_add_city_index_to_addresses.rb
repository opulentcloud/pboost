class AddCityIndexToAddresses < ActiveRecord::Migration
  def self.up
  	add_index :addresses, :city
  end

  def self.down
  	remove_index :addresses, :city
  end
end
