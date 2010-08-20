class SurveyQuestion < ActiveRecord::Base

	default_scope :order => :id

	#===== ASSOCIATIONS =======
	belongs_to :survey, :foreign_key => :contact_list_id
	has_many :answers, :class_name => 'SurveyAnswer', :dependent => :destroy
	accepts_nested_attributes_for :answers
	has_many :results, :class_name => 'VoterSurveyResult', :foreign_key => :question_id

	#===== VALIDATIONS =======
	validates_presence_of :question_text
	validates_uniqueness_of :question_text, :scope => :contact_list_id
	
	def total_responders
		t = 0
		self.results.summary.each do |r|
			t += r.count.to_i
		end
		t	
	end
	
end
