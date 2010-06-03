class CreateCitiesCouncilDistricts < ActiveRecord::Migration
  def self.up
    create_table :cities_council_districts, :id => false do |t|
      t.integer :city_id, :null => false, :primary => true
			t.integer :council_district_id, :null => false, :primary => true

      t.timestamps
    end
    add_index :cities_council_districts, :city_id
    add_index :cities_council_districts, :council_district_id
  end

  def self.down
    drop_table :cities_council_districts
  end
end
