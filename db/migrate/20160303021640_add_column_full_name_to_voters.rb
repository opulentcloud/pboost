class AddColumnFullNameToVoters < ActiveRecord::Migration
  def change
    add_column :voters, :full_name, :string, length: 100
  end
end
