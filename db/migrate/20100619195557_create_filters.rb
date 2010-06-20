class CreateFilters < ActiveRecord::Migration
  def self.up
    create_table :filters do |t|
      t.string :type, :limit => 64, :null => false
      t.string :string_val, :limit => 64
      t.integer :int_val
			t.integer :max_int_val
			t.references :walksheet

      t.timestamps
    end
    add_index :filters, :id, :unique => true
    add_index :filters, :type
  end

  def self.down
    drop_table :filters
  end
end
