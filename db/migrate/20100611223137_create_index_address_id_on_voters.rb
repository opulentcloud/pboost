class CreateIndexAddressIdOnVoters < ActiveRecord::Migration
  def self.up
		add_index :voters, :address_id
  end

  def self.down
		remove_index :voters, :address_id
  end
end
