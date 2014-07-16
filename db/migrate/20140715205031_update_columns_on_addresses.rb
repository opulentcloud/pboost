class UpdateColumnsOnAddresses < ActiveRecord::Migration
  def self.up
    change_column :addresses, :street_no_half, :string, limit: 10
    change_column :addresses, :street_prefix, :string, limit: 10
    change_column :addresses, :street_suffix, :string, limit: 10
    change_column :addresses, :street_name, :string, limit: 50
    change_column :addresses, :street_type, :string, limit: 10
    change_column :addresses, :apt_type, :string, limit: 10
    change_column :addresses, :apt_no, :string, limit: 20
  end
  def self.down
    change_column :addresses, :street_no_half, :string, limit: 10
    change_column :addresses, :street_prefix, :string, limit: 10
    change_column :addresses, :street_suffix, :string, limit: 10
    change_column :addresses, :street_name, :string, limit: 50
    change_column :addresses, :street_type, :string, limit: 10
    change_column :addresses, :apt_type, :string, limit: 10
    change_column :addresses, :apt_no, :string, limit: 20
  end
end
