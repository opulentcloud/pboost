class AddIsOddToAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :is_odd, :boolean
		add_index :addresses, :is_odd    
  end

  def self.down
    remove_column :addresses, :is_odd
  end
end
