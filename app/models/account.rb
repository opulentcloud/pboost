class Account < ActiveRecord::Base
	
	#===== CLASS ASSOCIATIONS ======
	belongs_to :organization
	
	#===== CLASS VALIDATIONS =====
	validates_presence_of :organization_id
		
	#===== INSTANCE METHODS ======
	def type_display
		self.class.to_s.gsub('Account','')
	end
		
end
