class AddDelayedJobIdToContactLists < ActiveRecord::Migration
  def self.up
    add_column :contact_lists, :delayed_job_id, :integer
  end

  def self.down
    remove_column :contact_lists, :delayed_job_id
  end
end
