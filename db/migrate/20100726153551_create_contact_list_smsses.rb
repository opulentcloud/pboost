class CreateContactListSmsses < ActiveRecord::Migration
  def self.up
    create_table :contact_list_smsses do |t|
      t.string :cell_phone, :limit => 10, :null => false
			t.references :contact_list

      t.timestamps
    end
    add_index :contact_list_smsses, :contact_list_id
  end

  def self.down
    drop_table :contact_list_smsses
  end
end
