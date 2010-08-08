class CreateContactLists < ActiveRecord::Migration
  def self.up
    create_table :contact_lists do |t|
      t.string :name, :limit => 100, :null => false
      t.integer :constituent_count
      t.boolean :populated, :default => false
      t.references :political_campaign, :null => false
      t.string :type, :null => false, :limit => 100
      
      t.timestamps
    end
    add_index :contact_lists, [:name, :type]
    add_index :contact_lists, [:political_campaign_id, :name, :type], :unique => true
  end
  
  def self.down
    drop_table :contact_lists
  end
end
