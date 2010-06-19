class AddIndexAddressIdOnAddresses < ActiveRecord::Migration
  def self.up
  	add_index :addresses, :id
  end

  def self.down
  	remove_index :addresses, :id
  end
end
