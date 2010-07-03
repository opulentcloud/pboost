require 'migration_helpers'

class CreateCityPrecincts < ActiveRecord::Migration
	extend MigrationHelpers
	
  def self.up
    create_table :city_precincts do |t|
      t.integer :city_id
      t.integer :precinct_id

      t.timestamps
    end
		add_index :city_precincts, :city_id
	  add_index :city_precincts, :precinct_id
  	add_index :city_precincts, [:city_id, :precinct_id], :unique => true
add_foreign_key :city_precincts, :city_id, :cities, 'ON DELETE RESTRICT'
add_foreign_key :city_precincts, :precinct_id, :precincts, 'ON DELETE RESTRICT'    
  end

  def self.down
    drop_table :city_precincts
  end
end
