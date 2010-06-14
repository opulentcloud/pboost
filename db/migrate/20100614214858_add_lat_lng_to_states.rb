class AddLatLngToStates < ActiveRecord::Migration
  def self.up
		add_column :states, :lat, :decimal, :precision => 15, :scale => 10
		add_column :states, :lng, :decimal, :precision => 15, :scale => 10
  end

  def self.down
		remove_column :states, :lat
		remove_column :states, :lng
  end
end
