class AddMcommDistCodeToAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :mcomm_dist_code, :string, :limit => 2
  end

  def self.down
    remove_column :addresses, :mcomm_dist_code
  end
end
