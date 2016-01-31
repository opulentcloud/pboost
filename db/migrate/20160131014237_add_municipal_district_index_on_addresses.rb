class AddMunicipalDistrictIndexOnAddresses < ActiveRecord::Migration
  def self.up
    Address.select("DISTINCT municipal_district").where("COALESCE(municipal_district,'') != ''").order(:municipal_district).each do |address|
      municipal_district = address.municipal_district.downcase.gsub(/\W/,'_').gsub('.','_')
      query = %{CREATE INDEX md_#{municipal_district}_idx ON addresses(municipal_district) WHERE municipal_district = $$#{address.municipal_district}$$}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end

  def self.down
    Address.select("DISTINCT municipal_district").where("COALESCE(municipal_district,'') != ''").order(:municipal_district).each do |address|
      municipal_district = address.municipal_district.downcase.gsub(/\W/,'_').gsub('.','_')
      query = %{DROP INDEX md_#{municipal_district}_idx}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end
end
