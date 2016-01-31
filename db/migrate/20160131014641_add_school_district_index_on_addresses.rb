class AddSchoolDistrictIndexOnAddresses < ActiveRecord::Migration
  def self.up
    Address.select("DISTINCT school_district").where("COALESCE(school_district,'') != ''").order(:school_district).each do |address|
      school_district = address.school_district.downcase.gsub(/\W/,'_').gsub('.','_')
      query = %{CREATE INDEX schd_#{school_district}_idx ON addresses(school_district) WHERE school_district = $$#{address.school_district}$$}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end

  def self.down
    Address.select("DISTINCT school_district").where("COALESCE(school_district,'') != ''").order(:school_district).each do |address|
      school_district = address.school_district.downcase.gsub(/\W/,'_').gsub('.','_')
      query = %{DROP INDEX schd_#{school_district}_idx}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end
end
