class AddDobIndexOnVoters < ActiveRecord::Migration
  def change
    add_index :voters, :dob
  end
end
