class AddStateIndexToAddresses < ActiveRecord::Migration
  def self.up
  	add_index :addresses, :state
  end

  def self.down
  	remove_index :addresses, :state
  end
end
