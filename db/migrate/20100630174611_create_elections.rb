class CreateElections < ActiveRecord::Migration
  def self.up
    create_table :elections do |t|
      t.string :description, :limit => 32, :null => false
      t.integer :year, :null => false
      t.string :election_type, :null => false

      t.timestamps
    end
    add_index :elections, :description, :unique => true
    add_index :elections, [:year, :election_type], :unique => true
  end

  def self.down
    drop_table :elections
  end
end
