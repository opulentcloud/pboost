class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :abbrev, limit: 2, null: false
      t.string :name, limit: 100, null: false
      t.boolean :active, null: false, default: true
      t.decimal :lat, precision: 15, scale: 10
      t.decimal :lng, precision: 15, scale: 10

      t.timestamps
    end
    add_index :states, :abbrev, unique: true
    add_index :states, :name, unique: true
  end
end
