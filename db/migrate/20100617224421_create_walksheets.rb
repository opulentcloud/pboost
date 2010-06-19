class CreateWalksheets < ActiveRecord::Migration
  def self.up
    create_table :walksheets do |t|
      t.string :name, :limit => 100, :null => false
      t.integer :consituent_count
      t.boolean :populated, :default => false
      t.references :political_campaign, :null => false
      
      t.timestamps
    end
    add_index :walksheets, :name
    add_index :walksheets, [:political_campaign_id, :name], :unique => true
  end
  
  def self.down
    drop_table :walksheets
  end
end
