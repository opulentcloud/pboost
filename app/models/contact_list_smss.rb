class ContactListSmss < ActiveRecord::Base
	acts_as_reportable

	#====== ASSOCIATIONS ======
	belongs_to :contact_list
	
end
