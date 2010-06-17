class AddIndexSexToVoters < ActiveRecord::Migration
  def self.up
  	add_index :voters, :sex
  end

  def self.down
  	remove_index :voters, :sex
  end
end
