class AddIndexVoterIdOnVoters < ActiveRecord::Migration
  def self.up
  	add_index :voters, :id
  end

  def self.down
  	remove_index :voters, :id
  end
end
