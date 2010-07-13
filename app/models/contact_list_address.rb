class ContactListAddress < ActiveRecord::Base

	#===== ASSOCIATIONS ======
	belongs_to :contact_list
	belongs_to :address

end
