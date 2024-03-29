class CreateVoters < ActiveRecord::Migration
  def self.up
    create_table :voters do |t|
    	t.integer :vote_builder_id, :limit => 8
      t.string :last_name, :limit => 32
      t.string :first_name, :limit => 32
      t.string :middle_name, :limit => 32
      t.string :suffix, :limit => 4
      t.string :salutation, :limit => 32
			t.string :phone, :limit => 10
			t.string :home_phone, :limit => 10
			t.string :work_phone, :limit => 10
			t.string :work_phone_ext, :limit => 10
			t.string :cell_phone, :limit => 10
			t.string :email, :limit => 50
			t.string :party, :limit => 1
			t.string :sex, :limit => 1
			t.integer :age, :limit => 1
			t.date :dob
			t.date :dor
			t.string :state_file_id, :limit => 10
			t.references :address
			t.string :search_index, :limit => 13

      t.timestamps
    end
		add_index :voters, :vote_builder_id, :unique => true    
		add_index :voters, :search_index
  end

  def self.down
    drop_table :voters
  end
end
