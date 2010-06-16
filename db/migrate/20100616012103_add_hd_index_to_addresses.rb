class AddHdIndexToAddresses < ActiveRecord::Migration
  def self.up
  	add_index :addresses, :hd
  end

  def self.down
  	remove_index :addresses, :hd
  end
end
