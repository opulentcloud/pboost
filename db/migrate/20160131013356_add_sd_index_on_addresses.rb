class AddSdIndexOnAddresses < ActiveRecord::Migration
  def self.up
    Address.select("DISTINCT sd").order(:sd).each do |address|
      sd = address.sd.downcase.gsub(/\W/,'_').gsub('.','_')
      query = %{CREATE INDEX sd_#{sd}_idx ON addresses(sd) WHERE sd = $$#{address.sd}$$}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end

  def self.down
    Address.select("DISTINCT sd").order(:sd).each do |address|
      sd = address.sd.downcase.gsub(/\W/,'_').gsub('.','_')
      query = %{DROP INDEX sd_#{sd}_idx}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end
end
