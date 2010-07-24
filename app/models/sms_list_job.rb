class SmsListJob < Struct.new(:sms_list_id)
	def perform
		SmsList.populate(sms_list_id)
	end
end
