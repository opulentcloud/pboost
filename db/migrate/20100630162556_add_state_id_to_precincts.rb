class AddStateIdToPrecincts < ActiveRecord::Migration
  def self.up
		add_column :precincts, :state_id, :integer

		add_index :precincts, :state_id
  end

  def self.down
  	remove_column :precincts, :state_id
  end
end
