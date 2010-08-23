class RemoveUniqueIndexFromAttachments < ActiveRecord::Migration
  def self.up
		remove_index :attachments,[:attachable_id, :attachable_type, :type]
  end

  def self.down
		add_index :attachments, [:attachable_id, :attachable_type, :type], :unique => true
  end
end
