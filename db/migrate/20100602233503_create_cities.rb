class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string :name, :limit => 64, :null => false
			t.references :state, :null => false

      t.timestamps
    end
		add_index :cities, :name
		add_index :cities, :state_id
    add_index :cities, [:name, :state_id], :unique => true
  end

  def self.down
    drop_table :cities
  end
end
