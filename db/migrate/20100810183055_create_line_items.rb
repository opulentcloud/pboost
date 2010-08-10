class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.decimal :unit_price, :precision => 13, :scale => 4
      t.references :product
      t.references :cart
      t.integer :quantity
      
      t.timestamps
    end
		add_index :line_items, :product_id
		add_index :line_items, :cart_id
  end
  
  def self.down
    drop_table :line_items
  end
end
