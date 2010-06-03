class CreateSenateDistricts < ActiveRecord::Migration
  def self.up
    create_table :senate_districts do |t|
      t.string :sd, :limit => 3, :null => false
			t.references :state, :null => false

      t.timestamps
    end
    add_index :senate_districts, [:state_id, :sd], :unique => true
  end

  def self.down
    drop_table :senate_districts
  end
end
