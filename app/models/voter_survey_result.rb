class VoterSurveyResult < ActiveRecord::Base

	named_scope :summary, :group => "question_id, answer", :select => "count(*), question_id, answer", :order => :answer

	#====== ASSOCIATIONS ======
	belongs_to :voter
	belongs_to :survey, :foreign_key => :contact_list_id
	belongs_to :survey_question

	#====== VALIDATIONS =======
	validates_presence_of :answer

	def response_percent(answer_responders, total_responders)
		((answer_responders.to_f / total_responders.to_f)*100).round(0)
	end

end
