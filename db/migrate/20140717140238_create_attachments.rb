class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :type, null: false
      t.string :attachable_type, null: false
      t.integer :attachable_id, null: false
      t.string :mime_type, null: false
      t.string :origin_url, null: false
      t.string :description, null: false
      t.string :attached_file

      t.timestamps
    end
    add_index :attachments, :type
    add_index :attachments, [:attachable_type, :attachable_id], name: 'idx_attachable_type_and_id'
  end
end
