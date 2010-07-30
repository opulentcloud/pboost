class PhoneBankListJob < Struct.new(:phone_bank_list_id)
	def perform
		PhoneBankList.populate(phone_bank_list_id)
	end
end

