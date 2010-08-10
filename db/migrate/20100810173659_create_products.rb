class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
			t.references :category
      t.string :name, :limit => 100
      t.decimal :price, :precision => 13, :scale => 4
      t.text :description
      
      t.timestamps
    end
		add_index :products, :category_id
		add_index :products, :name, :unique => true
  end
  
  def self.down
    drop_table :products
  end
end
