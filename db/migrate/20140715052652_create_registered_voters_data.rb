class CreateRegisteredVotersData < ActiveRecord::Migration
  def change
    create_table :registered_voters_data, id: false do |t|
      t.string :vtrid
      t.string :lastname
      t.string :firstname
      t.string :middlename
      t.string :suffix
      t.string :dob
      t.string :gender
      t.string :party
      t.string :house_number
      t.string :house_suffix
      t.string :street_predirection
      t.string :streetname      
      t.string :streettype
      t.string :street_postdirection
      t.string :unittype      
      t.string :unitnumber
      t.string :address
      t.string :non_std_address
      t.string :residentialcity      
      t.string :residentialstate
      t.string :residentialzip5
      t.string :residentialzip4
      t.string :mailingaddress
      t.string :mailingcity
      t.string :mailingstate      
      t.string :mailingzip5
      t.string :mailingzip4
      t.string :country
      t.string :status_code
      t.string :state_registration_date
      t.string :county_registration_date
      t.string :precinct      
      t.string :split
      t.string :county      
      t.string :congressional_districts
      t.string :legislative_districts
      t.string :councilmanic_districts
      t.string :ward_districts
      t.string :municipal_districts
      t.string :commissioner_districts      
      t.string :school_districts
      t.string :address_hash, limit: 32
    end
    execute "ALTER TABLE registered_voters_data ADD PRIMARY KEY (vtrid);"
  end
end
