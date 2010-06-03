require 'migration_helpers'

class AddForeignKeysToCitiesCouncilDistricts < ActiveRecord::Migration
	extend MigrationHelpers

  def self.up
    add_foreign_key :cities_council_districts, :city_id, :cities, 'ON DELETE CASCADE'
    add_foreign_key :cities_council_districts, :council_district_id, :council_districts, 'ON DELETE CASCADE'
  end

  def self.down
		remove_foreign_key :cities_council_districts, :city_id
		remove_foreign_key :cities_council_districts, :council_district_id
  end
end
