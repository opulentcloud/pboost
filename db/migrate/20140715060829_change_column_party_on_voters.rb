class ChangeColumnPartyOnVoters < ActiveRecord::Migration
  def change
    change_column :voters, :party, :string, limit: 5
  end
end
