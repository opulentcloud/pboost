class CreateMunicipalDistricts < ActiveRecord::Migration
  def self.up
    create_table :municipal_districts do |t|
      t.string :code, :limit => 3, :null => false

      t.timestamps
    end
    add_index :municipal_districts, :code, :unique => true
  end

  def self.down
    drop_table :municipal_districts
  end
end
