class AddCountyNameIndexesToAddresses < ActiveRecord::Migration
  def self.up
    Address.select("county_name").group(:county_name).order(:county_name).each do |address|
      county = address.county_name.downcase.gsub(/\W/,'_')
      query = %{CREATE INDEX ac_#{county}_idx ON addresses(county_name) WHERE county_name = $$#{address.county_name}$$}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end

  def self.down
    Address.select("county_name").group(:county_name).order(:county_name).each do |address|
      county = address.county_name.downcase.gsub(/\W/,'_')
      query = %{DROP INDEX ac_#{county}_idx}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end
end
