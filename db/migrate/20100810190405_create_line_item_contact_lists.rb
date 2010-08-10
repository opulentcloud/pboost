require 'migration_helpers'

class CreateLineItemContactLists < ActiveRecord::Migration
	extend MigrationHelpers

  def self.up
    create_table :line_item_contact_lists do |t|
      t.integer :line_item_id, :null => false
			t.integer :contact_list_id, :null => false

      t.timestamps
    end
		add_index :line_item_contact_lists,[:line_item_id, :contact_list_id], :unique => true
    add_index :line_item_contact_lists, :line_item_id
    add_index :line_item_contact_lists, :contact_list_id
add_foreign_key :line_item_contact_lists, :line_item_id, :line_items, 'ON DELETE RESTRICT'
add_foreign_key :line_item_contact_lists, :contact_list_id, :contact_lists, 'ON DELETE RESTRICT'

  end

  def self.down
    drop_table :line_item_contact_lists
  end
end

