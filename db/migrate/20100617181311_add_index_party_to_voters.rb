class AddIndexPartyToVoters < ActiveRecord::Migration
  def self.up
  	add_index :voters, :party
  end

  def self.down
  	remove_index :voters, :party
  end
end
