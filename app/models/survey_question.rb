class SurveyQuestion < ActiveRecord::Base

	belongs_to :survey, :foreign_key => :contact_list_id

	#===== VALIDATIONS =======
	validates_presence_of :question_text
	
end
