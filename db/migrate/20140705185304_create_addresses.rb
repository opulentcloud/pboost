class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street_no, limit: 10
      t.string :street_no_half, limit: 3
      t.string :street_prefix, limit: 2
      t.string :street_name, limit: 32
      t.string :street_type, limit: 4
      t.string :street_suffix, limit: 2
      t.string :apt_type, limit: 5
      t.string :apt_no, limit: 8
      t.string :city, limit: 32
      t.string :state, limit: 2
      t.string :zip5, limit: 5
      t.string :zip4, limit: 4
			t.string :county_name, limit: 32
			t.string :precinct_name, limit: 32
			t.string :precinct_code, limit: 32
			t.string :cd, limit: 3
			t.string :sd, limit: 3
			t.string :hd, limit: 3
			t.string :comm_dist_code, limit: 2
      t.decimal  :lat, precision: 15, scale: 10
      t.decimal  :lng, precision: 15, scale: 10
      #t.point 	 :geom, srid: 4326, null: true
			t.boolean :geo_failed
    	t.string :address_hash, limit: 32
    	t.boolean :is_odd
    	t.integer :street_no_int
    	
      t.timestamps
    end
    add_index :addresses, [:lat, :lng]
    add_index :addresses, :address_hash, unique: true
    add_index :addresses, :cd
    add_index :addresses, :street_name
    add_index :addresses, :city
    add_index :addresses, :comm_dist_code
    add_index :addresses, :county_name
    #add_index :addresses, :geom, spatial: true
    add_index :addresses, :hd
    add_index :addresses, :id
    add_index :addresses, :is_odd
    add_index :addresses, :precinct_code
    add_index :addresses, :sd
    add_index :addresses, :state
  end
end
