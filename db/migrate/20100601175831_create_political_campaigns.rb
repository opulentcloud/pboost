class CreatePoliticalCampaigns < ActiveRecord::Migration
  def self.up
    create_table :political_campaigns do |t|
      t.string :candidate_name, :limit => 64
      t.string :seat_sought, :limit => 128
      t.references :state, :null => false
      t.string :type, :limit => 20
      t.string :seat_type, :limit => 20
      t.references :congressional_district
      t.references :senate_district
      t.references :house_district
      t.references :county
      t.boolean :countywide, :null => false
      t.references :council_district
      t.references :city
      t.boolean :muniwide, :null => false
      t.references :organization

      t.timestamps
    end
    add_index :political_campaigns, :organization_id
		add_index :political_campaigns, :congressional_district_id
		add_index :political_campaigns, :senate_district_id
		add_index :political_campaigns, :house_district_id
		add_index :political_campaigns, :county_id
		add_index :political_campaigns, :city_id
    add_index :political_campaigns, :council_district_id
  end

  def self.down
    drop_table :political_campaigns
  end
end
