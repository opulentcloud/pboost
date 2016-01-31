class AddWardDistrictIndexOnAddresses < ActiveRecord::Migration
  def self.up
    Address.select("DISTINCT ward_district").where("COALESCE(ward_district,'') != ''").order(:ward_district).each do |address|
      ward_district = address.ward_district.downcase.gsub(/\W/,'_').gsub('.','_')
      query = %{CREATE INDEX wd_#{ward_district}_idx ON addresses(ward_district) WHERE ward_district = $$#{address.ward_district}$$}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end

  def self.down
    Address.select("DISTINCT ward_district").where("COALESCE(ward_district,'') != ''").order(:ward_district).each do |address|
      ward_district = address.ward_district.downcase.gsub(/\W/,'_').gsub('.','_')
      query = %{DROP INDEX wd_#{ward_district}_idx}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end
end
