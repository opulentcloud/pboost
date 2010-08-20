class SurveyAnswer < ActiveRecord::Base

	VALID_KEYS = [
		['0',	'0'],
		['1',	'1'],
		['2',	'2'],
		['3', '3'],
		['4', '4'],		
		['5', '5'],		
		['6', '6'],		
		['7', '7'],
		['8', '8'],		
		['9', '9'],
		['#', '#'],		
		['*', '*'],		
		['X', 'X']				
	]

	default_scope :order => :answer_key

	#====== ASSOCIATIONS ======
	belongs_to :survey_question
	has_one :survey, :through => :survey_question

	#====== VALIDATIONS =======
	validates_presence_of :answer_key, :answer_text
	validates_uniqueness_of :answer_key, :scope => :survey_question_id
	validates_uniqueness_of :answer_text, :scope => :survey_question_id

end
