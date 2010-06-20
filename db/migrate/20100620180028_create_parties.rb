class CreateParties < ActiveRecord::Migration
  def self.up
    create_table :parties do |t|
      t.string :code, :limit => 1, :null => false
      t.string :name, :limit => 32, :null => false

      t.timestamps
    end
    add_index :parties, :code, :unique => true
    add_index :parties, :name, :unique => true
  end

  def self.down
    drop_table :parties
  end
end
