class SmsList < ContactList
	acts_as_reportable
	
	def contact_list_id
		self.id
	end
	
	def filename(format)
		"sms_list_#{self.id}.#{format}"
	end
	
end

