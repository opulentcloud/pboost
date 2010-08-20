class VoterSurveyResult < ActiveRecord::Base

	#====== ASSOCIATIONS ======
	belongs_to :voter
	belongs_to :survey, :foreign_key => :contact_list_id
	belongs_to :survey_question

	#====== VALIDATIONS =======
	validates_presence_of :answer

end
