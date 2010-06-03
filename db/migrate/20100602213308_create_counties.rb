class CreateCounties < ActiveRecord::Migration
  def self.up
    create_table :counties do |t|
      t.string :name, :limit => 64, :null => false
      t.references :state, :null => false

      t.timestamps
    end
    add_index :counties, :name
    add_index :counties, [:state_id, :name], :unique => true
  end

  def self.down
    drop_table :counties
  end
end
