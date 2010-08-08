class SmsCampaignJob < Struct.new(:sms_campaign_id)
	def perform
		SmsCampaign.populate(sms_campaign_id)
	end
end
