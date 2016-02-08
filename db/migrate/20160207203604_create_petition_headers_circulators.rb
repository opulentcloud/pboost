class CreatePetitionHeadersCirculators < ActiveRecord::Migration
  def change
    create_table :petition_headers_circulators, id: false do |t|
      t.belongs_to :petition_header, index: true
      t.belongs_to :circulator, index: true
    end
    add_index :petition_headers_circulators, [:petition_header_id, :circulator_id], name: :uniq_pet_head_idx, unique: true
  end
end
