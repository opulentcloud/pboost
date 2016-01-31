class AddPrecintCodeIndexesOnAddresses < ActiveRecord::Migration
  def self.up
    Address.select("precinct_code").group(:precinct_code).order(:precinct_code).each do |address|
      precinct_code = address.precinct_code.downcase.gsub(/\W/,'_').gsub('.','_')
      query = %{CREATE INDEX pc_#{precinct_code}_idx ON addresses(precinct_code) WHERE precinct_code = $$#{address.precinct_code}$$}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end

  def self.down
    Address.select("precinct_code").group(:precinct_code).order(:precinct_code).each do |address|
      precinct_code = address.precinct_code.downcase.gsub(/\W/,'_').gsub('.','_')
      query = %{DROP INDEX pc_#{precinct_code}_idx}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end
end
