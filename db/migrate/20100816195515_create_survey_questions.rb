class CreateSurveyQuestions < ActiveRecord::Migration
		def self.up
		  create_table :survey_questions do |t|
		    t.text :question_text, :null => false
				t.references :contact_list

		    t.timestamps
		  end
		  add_index :survey_questions, :contact_list_id
  end

  def self.down
    drop_table :survey_questions
  end
end
