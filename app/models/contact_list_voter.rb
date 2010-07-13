class ContactListVoter < ActiveRecord::Base

	#===== ASSOCIATIONS ======
	belongs_to :contact_list
	belongs_to :voter

end
