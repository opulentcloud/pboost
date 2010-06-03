class CreateHouseDistricts < ActiveRecord::Migration
  def self.up
    create_table :house_districts do |t|
      t.string :hd, :limit => 3, :null => false
			t.references :state, :null => false

      t.timestamps
    end
    add_index :house_districts, [:state_id, :hd], :unique => true
  end

  def self.down
    drop_table :house_districts
  end
end
