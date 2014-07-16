class ChangeColumnSuffixOnVoters < ActiveRecord::Migration
  def self.up
    change_column :voters, :suffix, :string, limit: 30
  end
  def self.down
    change_column :voters, :suffix, :string, limit: 30
  end
end
