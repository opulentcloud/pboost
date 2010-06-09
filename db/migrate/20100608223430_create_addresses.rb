class CreateAddresses < ActiveRecord::Migration
  def self.up    
    create_table :addresses do |t|
      t.string :street_no, :limit => 5
      t.string :street_no_half, :limit => 3
      t.string :street_prefix, :limit => 2
      t.string :street_name, :limit => 32
      t.string :street_type, :limit => 4
      t.string :street_suffix, :limit => 2
      t.string :apt_type, :limit => 5
      t.string :apt_no, :limit => 8
      t.string :city, :limit => 32
      t.string :state, :limit => 2
      t.string :zip5, :limit => 5
      t.string :zip4, :limit => 4
			t.string :county_name, :limit => 32
			t.string :precinct_name, :limit => 32
			t.string :precinct_code, :limit => 32
			t.string :cd, :limit => 3
			t.string :sd, :limit => 3
			t.string :hd, :limit => 3
			t.string :comm_dist_code, :limit => 2
      t.decimal  :lat, :precision => 15, :scale => 10
      t.decimal  :lng, :precision => 15, :scale => 10
      t.point 	 :geom, :srid => 4326, :null => true
			t.boolean :geo_failed
    	t.string :address_hash, :limit => 32

			t.timestamps
    end
  	add_index "addresses", ["lat", "lng"], :name => "index_addresses_on_lat_and_lng"
    add_index :addresses, :geom, :spatial => true
		add_index :addresses, :address_hash, :unique => true
  end
  
  def self.down
    drop_table :addresses
  end
end
