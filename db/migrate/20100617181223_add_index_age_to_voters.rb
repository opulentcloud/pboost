class AddIndexAgeToVoters < ActiveRecord::Migration
  def self.up
  	add_index :voters, :age
  end

  def self.down
  	remove_index :voters, :age
  end
end
