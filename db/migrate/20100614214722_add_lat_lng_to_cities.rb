class AddLatLngToCities < ActiveRecord::Migration
  def self.up
		add_column :cities, :lat, :decimal, :precision => 15, :scale => 10
		add_column :cities, :lng, :decimal, :precision => 15, :scale => 10
  end

  def self.down
		remove_column :cities, :lat
		remove_column :cities, :lng
  end
end
