class UpdateGeomColumnOnAddresses < ActiveRecord::Migration
  def self.up
    #add_column :addresses, :geom, :point, geographic: true
  end
  
  def self.down
    #remove_column :addresses, :geom
  end
end
