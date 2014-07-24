class AddSearchIndex2ToVoters < ActiveRecord::Migration
  def change
    add_column :voters, :search_index2, :string, limit: 12
    add_index :voters, :search_index2
  end
end
