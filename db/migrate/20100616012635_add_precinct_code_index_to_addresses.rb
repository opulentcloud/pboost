class AddPrecinctCodeIndexToAddresses < ActiveRecord::Migration
  def self.up
  	add_index :addresses, :precinct_code
  end

  def self.down
  	remove_index :addresses, :precinct_code
  end
end
