class ChangeColumnCommDistCode < ActiveRecord::Migration
  def self.up
    change_column :addresses, :comm_dist_code, :string, limit: 3
  end
  def self.down
    change_column :addresses, :comm_dist_code, :string, limit: 3
  end
end
