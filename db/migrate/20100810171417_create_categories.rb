class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name, :limit => 100
      
      t.timestamps
    end
    add_index :categories, :name, :unique => true
  end
  
  def self.down
    drop_table :categories
  end
end
