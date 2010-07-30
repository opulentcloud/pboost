class AddStatusToContactListSmsses < ActiveRecord::Migration
  def self.up
    add_column :contact_list_smsses, :status, :string, :limit => 4
		add_index :contact_list_smsses, :status
  end

  def self.down
    remove_column :contact_list_smsses, :status
  end
end
