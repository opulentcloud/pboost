class AddHdIndexOnAddresses < ActiveRecord::Migration
  def self.up
    Address.select("DISTINCT hd").order(:hd).each do |address|
      hd = address.hd.downcase.gsub(/\W/,'_').gsub('.','_')
      query = %{CREATE INDEX hd_#{hd}_idx ON addresses(hd) WHERE hd = $$#{address.hd}$$}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end

  def self.down
    Address.select("DISTINCT hd").order(:hd).each do |address|
      hd = address.hd.downcase.gsub(/\W/,'_').gsub('.','_')
      query = %{DROP INDEX hd_#{hd}_idx}
      ActiveRecord::Base.connection.execute(query, :skip_logging)
    end
  end
end
