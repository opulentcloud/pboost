class AddColumnYorToVoters < ActiveRecord::Migration
  def change
    add_column :voters, :yor, :integer
  end
end
