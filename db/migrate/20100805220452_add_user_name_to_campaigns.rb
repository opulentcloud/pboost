class AddUserNameToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :user_name, :string, :limit => 100
  end

  def self.down
    remove_column :campaigns, :user_name
  end
end
