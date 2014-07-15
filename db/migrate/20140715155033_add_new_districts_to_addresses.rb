class AddNewDistrictsToAddresses < ActiveRecord::Migration
  def change
    change_table :addresses do |t|
      t.string :ward_district, limit: 10
      t.string :municipal_district, limit: 10
      t.string :commissioner_district, limit: 10
      t.string :school_district, limit: 10
      t.index :ward_district
      t.index :municipal_district
      t.index :commissioner_district
      t.index :school_district
    end
  end
end

