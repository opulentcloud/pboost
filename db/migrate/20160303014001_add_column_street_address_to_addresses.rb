class AddColumnStreetAddressToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :street_address, :string
  end
end
