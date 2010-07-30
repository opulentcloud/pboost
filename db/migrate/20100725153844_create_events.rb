class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.datetime :event_date
      t.string :event_code, :limit => 25 
      t.text :event_message
			t.references :contact_list
			t.references :address
			t.references :voter
			t.references :eventable, :polymorphic => true
			t.string :type, :limit => 64
			t.integer :delayed_job_id
			
      t.timestamps
    end
		add_index :events, :contact_list_id
		add_index :events, :address_id
		add_index :events, :voter_id
		add_index :events, :eventable_id
		add_index :events, :eventable_type
		add_index :events, :type
  end

  def self.down
    drop_table :events
  end
end
