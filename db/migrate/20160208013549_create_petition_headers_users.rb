class CreatePetitionHeadersUsers < ActiveRecord::Migration
  def change
    create_table :petition_headers_users, id: false do |t|
      t.belongs_to :petition_header, index: true
      t.belongs_to :user, index: true
    end
    add_index :petition_headers_users, [:petition_header_id, :user_id], name: :uniq_pet_head_users_idx, unique: true
  end
end

