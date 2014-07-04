class CreateDelayedJobResults < ActiveRecord::Migration
  def change
    create_table :delayed_job_results do |t|
      t.integer :job_id, null: false

      t.timestamps
    end
    add_index :delayed_job_results, :job_id, unique: true
  end
end
