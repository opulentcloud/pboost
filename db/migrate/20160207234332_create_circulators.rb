class CreateCirculators < ActiveRecord::Migration
  def change
    create_table :circulators do |t|
      t.string :first_name, limit: 32, index: true
      t.string :last_name, limit: 32, index: true
      t.string :name, null: false, limit: 65
      t.string :address, limit: 100, null: false
      t.string :city, limit: 32, null: false
      t.string :state, limit: 2, null: false
      t.string :zip, limit: 5, null: false
      t.string :phone_number, limit: 10, null: false

      t.timestamps
    end
  end
end
