class AddCommDistCodeIndexToAddresses < ActiveRecord::Migration
  def self.up
  	add_index :addresses, :comm_dist_code
  end

  def self.down
  	remove_index :addresses, :comm_dist_code
  end
end
