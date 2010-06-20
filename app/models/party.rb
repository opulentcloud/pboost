class Party < ActiveRecord::Base
	#===== SCOPES =====
	default_scope :order => :code
	
	#===== VALIDATIONS =====
	validates_presence_of :name, :code
	
end
