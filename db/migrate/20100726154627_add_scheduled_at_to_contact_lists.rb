class AddScheduledAtToContactLists < ActiveRecord::Migration
  def self.up
    add_column :contact_lists, :scheduled_at, :datetime
  end

  def self.down
    remove_column :contact_lists, :scheduled_at
  end
end
