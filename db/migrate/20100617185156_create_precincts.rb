class CreatePrecincts < ActiveRecord::Migration
  def self.up
    create_table :precincts do |t|
      t.string :name, :limit => 32, :null => false
      t.string :code, :limit => 32, :null => false
			t.references :county
			t.references :congressional_district
			t.references :senate_district
			t.references :house_district
			t.references :council_district

      t.timestamps
    end
    add_index :precincts, :name
    add_index :precincts, :code
    add_index :precincts, [:name, :code], :unique => true
    add_index :precincts, :county_id
		add_index :precincts, [:code, :county_id], :unique => true
    add_index :precincts, :congressional_district_id
		add_index :precincts, [:code, :congressional_district_id], :unique => true
    add_index :precincts, :senate_district_id
		add_index :precincts, [:code, :senate_district_id], :unique => true
    add_index :precincts, :house_district_id
		add_index :precincts, [:code, :house_district_id], :unique => true
    add_index :precincts, :council_district_id
		add_index :precincts, [:code, :council_district_id], :unique => true
		
  end

  def self.down
    drop_table :precincts
  end
end
