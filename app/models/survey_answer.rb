class SurveyAnswer < ActiveRecord::Base

	#====== ASSOCIATIONS ======
	belongs_to :survey_question
	has_one :survey, :through => :survey_question

	#====== VALIDATIONS =======
	validates_presence_of :survey_question_id, :answer_key, :answer_text
	validates_uniqueness_of :answer_key, :scope => :survey_question_id
	validates_uniqueness_of :answer_text, :scope => :survey_question_id

end
