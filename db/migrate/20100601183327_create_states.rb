class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string :abbrev, :limit => 2, :null => false
      t.string :name, :limit => 100, :null => false
      t.boolean :active, :default => true

      t.timestamps
    end
    add_index :states, :abbrev, :unique => true
    add_index :states, :name, :unique => true
  end

  def self.down
    drop_table :states
  end
end
