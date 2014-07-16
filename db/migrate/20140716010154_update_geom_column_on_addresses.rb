class UpdateGeomColumnOnAddresses < ActiveRecord::Migration
  def self.up
    remove_column :addresses, :geom
    add_column :addresses, :geom, :point, geographic: true
  end
  
  def self.down
    add_column :addresses, :geom, :point, srid: 4326
  end
end
