class DropWalksheetIdFromFilters < ActiveRecord::Migration
  def self.up
  	remove_column :filters, :walksheet_id
  end

  def self.down
  	add_column :filters, :walksheet_id, :integer
  end
end
