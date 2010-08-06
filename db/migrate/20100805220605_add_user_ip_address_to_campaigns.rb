class AddUserIpAddressToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :user_ip_address, :string, :limit => 32
  end

  def self.down
    remove_column :campaigns, :user_ip_address
  end
end
