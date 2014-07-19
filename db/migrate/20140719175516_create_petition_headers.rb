class CreatePetitionHeaders < ActiveRecord::Migration
  def change
    create_table :petition_headers do |t|
      t.string :voters_of, default: ""
      t.boolean :baltimore_city, default: false
      t.string :party_affiliation, default: ""
      t.boolean :unaffiliated, default: false
      t.string :name, default: ""
      t.string :address, default: ""
      t.string :office_and_district, default: ""
      t.string :ltgov_name, default: ""
      t.string :ltgov_address, default: ""

      t.timestamps
    end
  end
end
