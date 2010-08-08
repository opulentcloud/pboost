class FixAttachmentsIndexes < ActiveRecord::Migration
  def self.up
		remove_index :attachments, [:attachable_id, :attachable_type]
		add_index :attachments, [:attachable_id, :attachable_type]
		add_index :attachments, [:attachable_id, :attachable_type, :type], :unique => true
  end

  def self.down
		remove_index :attachments, [:attachable_id, :attachable_type, :type]
		remove_index :attachments, [:attachable_id, :attachable_type]
		add_index :attachments, [:attachable_id, :attachable_type], :unique => true
  end
end
