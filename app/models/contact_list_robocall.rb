class ContactListRobocall < ActiveRecord::Base
	acts_as_reportable

	#====== ASSOCIATIONS ======
	belongs_to :contact_list

	#export with a leading one
	def phone_mumber 
		"1#{self.phone}"
	end
	
end
