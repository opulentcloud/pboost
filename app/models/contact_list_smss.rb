class ContactListSmss < ActiveRecord::Base
	acts_as_reportable

	#===== SCOPES ======
	named_scope :unsent, :conditions => 'contact_list_smsses.status IS NULL'

	#====== ASSOCIATIONS ======
	belongs_to :contact_list
	
	def send_status_display
		ClubTexting.translate_response(self.status)
	end
	
end
