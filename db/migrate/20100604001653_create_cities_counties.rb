require 'migration_helpers'

class CreateCitiesCounties < ActiveRecord::Migration
	extend MigrationHelpers

  def self.up
    create_table :cities_counties, :id => false do |t|
      t.integer :city_id, :null => false, :primary => true
			t.integer :county_id, :null => false, :primary => true

      t.timestamps
    end
    add_index :cities_counties, :city_id
    add_index :cities_counties, :county_id
add_foreign_key :cities_counties, :city_id, :cities, 'ON DELETE CASCADE'
   add_foreign_key :cities_counties, :county_id, :counties, 'ON DELETE CASCADE'
  end

  def self.down
    drop_table :cities_counties
  end
end
