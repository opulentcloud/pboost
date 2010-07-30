class SmsListSendJob < Struct.new(:sms_list_id)
	def perform
		SmsList.send!(sms_list_id)
	end
end
