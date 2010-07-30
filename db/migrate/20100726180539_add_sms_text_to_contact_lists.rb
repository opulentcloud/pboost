class AddSmsTextToContactLists < ActiveRecord::Migration
  def self.up
    add_column :contact_lists, :sms_text, :text
  end

  def self.down
    remove_column :contact_lists, :sms_text
  end
end
