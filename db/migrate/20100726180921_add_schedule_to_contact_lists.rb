class AddScheduleToContactLists < ActiveRecord::Migration
  def self.up
    add_column :contact_lists, :schedule, :boolean, :default => false
  end

  def self.down
    remove_column :contact_lists, :schedule
  end
end
