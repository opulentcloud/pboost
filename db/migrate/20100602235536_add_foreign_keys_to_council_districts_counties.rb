require 'migration_helpers'

class AddForeignKeysToCouncilDistrictsCounties < ActiveRecord::Migration
	extend MigrationHelpers

  def self.up
    add_foreign_key :council_districts_counties, :county_id, :counties, 'ON DELETE CASCADE'
    add_foreign_key :council_districts_counties, :council_district_id, :council_districts, 'ON DELETE CASCADE'
  end

  def self.down
		remove_foreign_key :council_districts_counties, :county_id
		remove_foreign_key :council_districts_counties, :council_district_id
  end
end
