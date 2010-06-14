class AddLatLngToCounties < ActiveRecord::Migration
  def self.up
		add_column :counties, :lat, :decimal, :precision => 15, :scale => 10
		add_column :counties, :lng, :decimal, :precision => 15, :scale => 10
  end

  def self.down
		remove_column :counties, :lat
		remove_column :counties, :lng
  end
end
