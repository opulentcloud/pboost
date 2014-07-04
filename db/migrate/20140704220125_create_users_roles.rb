class CreateUsersRoles < ActiveRecord::Migration
  def change
    create_table :users_roles do |t|
      t.integer :user_id, null: false
      t.integer :role_id, null: false
      
      t.timestamps
    end
    add_reference :users_roles, :users, index: true
    add_reference :users_roles, :roles, index: true
    add_index :users_roles, [:user_id, :role_id], unique: true
  end
end
