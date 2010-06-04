class CreateCouncilDistrictsCounties < ActiveRecord::Migration
  def self.up
    create_table :council_districts_counties, :id => false do |t|
      t.integer :county_id, :null => false, :primary => true
			t.integer :council_district_id, :null => false, :primary => true

      t.timestamps
    end
    add_index :council_districts_counties, :county_id
    add_index :council_districts_counties, :council_district_id
  end

  def self.down
    drop_table :council_districts_counties
  end
end
