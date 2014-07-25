class CreateVerifications < ActiveRecord::Migration
  def change
    create_table :verifications do |t|
      t.string :impfile
      t.string :expfile
      t.string :status, limit: 50

      t.timestamps
    end
    add_reference :verifications, :user, index: true
  end
end
