class AddCdcIndexOnAddresses < ActiveRecord::Migration
  def self.up
    Address.select("DISTINCT comm_dist_code").where("COALESCE(comm_dist_code,'') != ''").order(:comm_dist_code).each do |address|
      comm_dist_code = address.comm_dist_code.downcase.gsub(/\W/,'_').gsub('.','_')
      query = %{CREATE INDEX cdc_#{comm_dist_code}_idx ON addresses(comm_dist_code) WHERE comm_dist_code = $$#{address.comm_dist_code}$$}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end

  def self.down
    Address.select("DISTINCT comm_dist_code").where("COALESCE(comm_dist_code,'') != ''").order(:comm_dist_code).each do |address|
      comm_dist_code = address.comm_dist_code.downcase.gsub(/\W/,'_').gsub('.','_')
      query = %{DROP INDEX cdc_#{comm_dist_code}_idx}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end
end
