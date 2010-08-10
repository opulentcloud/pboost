class CreateAccounts < ActiveRecord::Migration
  def self.up
	  create_table :accounts do |t|
      t.string :type, :limit => 14
			t.references :organization
      t.decimal :current_balance, :precision => 11, :scale => 2, :default => 0

      t.timestamps
		end
		add_index :accounts, :organization_id, :unique => true
		add_index :accounts, [:id, :type]
  end

  def self.down
		drop_table :accounts		
  end
end
