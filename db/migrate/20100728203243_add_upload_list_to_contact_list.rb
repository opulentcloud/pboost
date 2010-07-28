class AddUploadListToContactList < ActiveRecord::Migration
  def self.up
    add_column :contact_lists, :upload_list, :boolean
  end

  def self.down
    remove_column :contact_lists, :upload_list
  end
end
