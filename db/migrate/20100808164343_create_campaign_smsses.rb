class CreateCampaignSmsses < ActiveRecord::Migration
		def self.up
		  create_table :campaign_smsses do |t|
		    t.string :cell_phone, :limit => 10, :null => false
			  t.string :status, :limit => 4
				t.references :campaign

		    t.timestamps
		  end
		  add_index :campaign_smsses, :campaign_id
			add_index :campaign_smsses, :status
			add_index :campaign_smsses, [:campaign_id, :cell_phone], :unique => true
  end

  def self.down
    drop_table :campaign_smsses
  end
end
