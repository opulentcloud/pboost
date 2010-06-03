class CreateCongressionalDistricts < ActiveRecord::Migration
  def self.up
    create_table :congressional_districts do |t|
      t.string :cd, :limit => 3, :null => false
			t.references :state, :null => false

      t.timestamps
    end
    add_index :congressional_districts, [:state_id, :cd], :unique => true
  end

  def self.down
    drop_table :congressional_districts
  end
end
