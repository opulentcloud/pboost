class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
			t.integer :cart_id
      t.string :ip_address, :limit => 50
			t.string :first_name, :limit => 32, :null => false
			t.string :last_name, :limit => 32, :null => false
			t.string :card_type, :limit => 32
			t.date :card_expires_on
      
      t.timestamps
    end
		add_index :orders, :cart_id
  end
  
  def self.down
    drop_table :orders
  end
end
