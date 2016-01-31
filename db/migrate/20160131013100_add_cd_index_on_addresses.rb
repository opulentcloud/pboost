class AddCdIndexOnAddresses < ActiveRecord::Migration
  def self.up
    Address.select("DISTINCT cd").order(:cd).each do |address|
      cd = address.cd.downcase.gsub(/\W/,'_').gsub('.','_')
      query = %{CREATE INDEX cd_#{cd}_idx ON addresses(cd) WHERE cd = $$#{address.cd}$$}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end

  def self.down
    Address.select("DISTINCT cd").order(:cd).each do |address|
      cd = address.cd.downcase.gsub(/\W/,'_').gsub('.','_')
      query = %{DROP INDEX cd_#{cd}_idx}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end
end
