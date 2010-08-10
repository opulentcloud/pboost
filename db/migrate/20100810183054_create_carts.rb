class CreateCarts < ActiveRecord::Migration
  def self.up
    create_table :carts do |t|
			t.references :user
      t.datetime :purchased_at

      t.timestamps
    end
		add_index :carts, :user_id
  end

  def self.down
    drop_table :carts
  end
end
