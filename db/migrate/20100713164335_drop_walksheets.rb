class DropWalksheets < ActiveRecord::Migration
  def self.up
  	drop_table :walksheets
  end

  def self.down
    create_table :walksheets do |t|
      t.string :name, :limit => 100, :null => false
      t.integer :constituent_count
      t.boolean :populated, :default => false
      t.references :political_campaign, :null => false
      
      t.timestamps
    end
    add_index :walksheets, :name
    add_index :walksheets, [:political_campaign_id, :name], :unique => true
  end
end
