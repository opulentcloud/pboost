class NormalizeCountyNamesOnAddresses < ActiveRecord::Migration
  def self.up
    query = %{UPDATE addresses SET county_name = "Saint Mary's" WHERE county_name = "St. Mary's"}
  end
  def self.down
  end
end
