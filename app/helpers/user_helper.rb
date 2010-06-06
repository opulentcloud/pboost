module UserHelper

	def format_phone_number(phone)
		return '' unless !phone.nil?
		number_to_phone(phone)
	end

end
