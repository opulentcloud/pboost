class CreateTimeZones < ActiveRecord::Migration
  def self.up
    create_table :time_zones do |t|
      t.string :zone, :null => false, :limit => 64

      t.timestamps
    end
		add_index :time_zones, :zone, :unique => true    
  end

  def self.down
    drop_table :time_zones
  end
end
