class CreatePoliticalCampaigns < ActiveRecord::Migration
  def self.up
    create_table :political_campaigns do |t|
      t.string :candidate_name, :limit => 64
      t.string :seat_sought, :limit => 128
      t.string :state_abbrev, :limit => 2
      t.string :type, :limit => 9
      t.string :seat_type, :limit => 15
      t.string :cd, :limit => 3
      t.string :sd, :limit => 3
      t.string :hd, :limit => 3
      t.string :county, :limit => 32
      t.boolean :countywide, :null => false
      t.string :comm_dist_code, :limit => 2
      t.string :municipality, :limit => 32
      t.boolean :muniwide, :null => false
      t.references :organization

      t.timestamps
    end
  end

  def self.down
    drop_table :political_campaigns
  end
end
