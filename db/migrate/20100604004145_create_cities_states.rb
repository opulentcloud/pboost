require 'migration_helpers'

class CreateCitiesStates < ActiveRecord::Migration
	extend MigrationHelpers

  def self.up
    create_table :cities_states, :id => false do |t|
      t.integer :city_id, :null => false, :primary => true
			t.integer :state_id, :null => false, :primary => true

      t.timestamps
    end
    add_index :cities_states, :city_id
    add_index :cities_states, :state_id
add_foreign_key :cities_states, :city_id, :cities, 'ON DELETE CASCADE'
   add_foreign_key :cities_states, :state_id, :states, 'ON DELETE CASCADE'
  end

  def self.down
    drop_table :cities_states
  end
end
