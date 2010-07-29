class AddMappedFieldsToContactLists < ActiveRecord::Migration
  def self.up
    add_column :contact_lists, :mapped_fields, :text
  end

  def self.down
    remove_column :contact_lists, :mapped_fields
  end
end
