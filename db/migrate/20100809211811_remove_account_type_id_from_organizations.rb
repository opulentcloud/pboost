class RemoveAccountTypeIdFromOrganizations < ActiveRecord::Migration
  def self.up
		remove_column :organizations, :account_type_id, :integer
  end

  def self.down
  	add_column :organizations, :account_type_id, :integer
  end
end
