class UpdateGeomColumnOnAddresses < ActiveRecord::Migration
  def change
    change_column :addresses, :geom, :point, geographic: true
  end
end
