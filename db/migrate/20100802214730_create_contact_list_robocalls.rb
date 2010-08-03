class CreateContactListRobocalls < ActiveRecord::Migration
  def self.up
    create_table :contact_list_robocalls do |t|
      t.string :phone, :limit => 10, :null => false
			t.references :contact_list

      t.timestamps
    end
    add_index :contact_list_robocalls, :contact_list_id
  end

  def self.down
    drop_table :contact_list_robocalls
  end
end
