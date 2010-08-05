class CreateCampaigns < ActiveRecord::Migration
   def self.up
    create_table :campaigns do |t|
      t.string :type, :limit => 100, :null => false
			t.string :name, :limit => 100, :null => false
      t.datetime :scheduled_at
			t.string :caller_id, :limit => 10
			t.boolean :single_sound_file
			t.boolean :scrub_dnc
      t.text :sms_text
			t.references :delayed_job
			t.references :contact_list

      t.timestamps
    end
    add_index :campaigns, [:id, :type], :uniq => true
		add_index :campaigns, [:type, :name], :uniq => true
    add_index :campaigns, [:delayed_job_id]
    add_index :campaigns, [:contact_list_id]
  end

  def self.down
    drop_table :campaigns
  end
end
