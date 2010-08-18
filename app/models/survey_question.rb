class SurveyQuestion < ActiveRecord::Base

	#===== ASSOCIATIONS =======
	belongs_to :survey, :foreign_key => :contact_list_id
	has_many :answers, :class_name => 'SurveyAnswer'
	accepts_nested_attributes_for :answers

	#===== VALIDATIONS =======
	validates_presence_of :question_text
	validates_uniqueness_of :question_text, :scope => :contact_list_id
	
end
