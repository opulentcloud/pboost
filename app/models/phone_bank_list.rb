class PhoneBankList < ContactList
	acts_as_reportable
	
	def contact_list_id
		self.id
	end
	
end

