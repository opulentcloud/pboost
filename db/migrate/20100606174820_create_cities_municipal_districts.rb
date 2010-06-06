require 'migration_helpers'

class CreateCitiesMunicipalDistricts < ActiveRecord::Migration
	extend MigrationHelpers

  def self.up
    create_table :cities_municipal_districts, :id => false do |t|
      t.integer :city_id, :null => false, :primary => true
			t.integer :municipal_district_id, :null => false, :primary => true

      t.timestamps
    end
    add_index :cities_municipal_districts, :city_id
    add_index :cities_municipal_districts, :municipal_district_id
add_foreign_key :cities_municipal_districts, :city_id, :cities, 'ON DELETE CASCADE'
add_foreign_key :cities_municipal_districts, :municipal_district_id, :municipal_districts, 'ON DELETE CASCADE'

  end

  def self.down
    drop_table :cities_municipal_districts
  end
end

