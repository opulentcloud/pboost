class AddCdIndexToAddresses < ActiveRecord::Migration
  def self.up
  	add_index :addresses, :cd
  end

  def self.down
		remove_index :addresses, :cd
  end
end
