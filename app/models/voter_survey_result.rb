class VoterSurveyResult < ActiveRecord::Base

	named_scope :summary, :group => "question_id, answer", :select => "count(*), question_id, answer"

	#====== ASSOCIATIONS ======
	belongs_to :voter
	belongs_to :survey, :foreign_key => :contact_list_id
	belongs_to :survey_question

	#====== VALIDATIONS =======
	validates_presence_of :answer

end
