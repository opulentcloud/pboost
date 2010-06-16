class AddSdIndexToAddresses < ActiveRecord::Migration
  def self.up
  	add_index :addresses, :sd
  end

  def self.down
  	remove_index :addresses, :sd
  end
end
