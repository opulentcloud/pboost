class CreateCouncilDistricts < ActiveRecord::Migration
  def self.up
    create_table :council_districts do |t|
      t.string :code, :limit => 3, :null => false

      t.timestamps
    end
    add_index :council_districts, :code, :unique => true
  end

  def self.down
    drop_table :council_districts
  end
end
