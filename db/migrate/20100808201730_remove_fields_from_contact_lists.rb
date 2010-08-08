class RemoveFieldsFromContactLists < ActiveRecord::Migration
  def self.up
  	remove_column :contact_lists, :delayed_job_id
  	remove_column :contact_lists, :schedule
  	remove_column :contact_lists, :sms_text
  	remove_column :contact_lists, :scheduled_at
  end

  def self.down
		add_column :contact_lists, :delayed_job_id, :integer  
		add_column :contact_lists, :schedule, :boolean, :default => false		
		add_column :contact_lists, :sms_text, :text
		add_column :contact_lists, :scheduled_at, :datetime
  end
end
