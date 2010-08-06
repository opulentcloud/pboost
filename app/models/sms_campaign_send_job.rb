class SmsCampaignSendJob < Struct.new(:sms_campaign_id)
	def perform
		SmsCampaign.send!(sms_campaign_id)
	end
end
