class ChangeColumnPartyOnVoters < ActiveRecord::Migration
  def self.up
    change_column :voters, :party, :string, limit: 5
  end
  def self.down
    change_column :voters, :party, :string, limit: 5
  end
end
