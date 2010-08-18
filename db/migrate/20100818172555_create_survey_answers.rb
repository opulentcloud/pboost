class CreateSurveyAnswers < ActiveRecord::Migration
  def self.up
    create_table :survey_answers do |t|
			t.references :survey_question
			t.string :answer_key, :limit => 1, :null => false
      t.text :answer_text, :null => false

      t.timestamps
    end
		add_index :survey_answers, :survey_question_id
		add_index :survey_answers,  [:survey_question_id, :answer_key], :unique => true
		add_index :survey_answers, [:survey_question_id, :answer_text], :unique => true
  end

  def self.down
    drop_table :survey_answers
  end
end
