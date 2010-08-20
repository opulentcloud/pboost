class CreateVoterSurveyResults < ActiveRecord::Migration
  def self.up
    create_table :voter_survey_results do |t|
      t.integer :voter_id
      t.integer :contact_list_id
      t.integer :question_id
      t.string :answer, :limit => 1, :null => false

      t.timestamps
    end
    add_index :voter_survey_results, :voter_id
    add_index :voter_survey_results, :contact_list_id    
    add_index :voter_survey_results, [:voter_id, :contact_list_id, :question_id], :unique => true    
  end

  def self.down
    drop_table :voter_survey_results
  end
end
