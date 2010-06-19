class PoliticalCampaignJob < Struct.new(:political_campaign_id)
	def perform
		PoliticalCampaign.populate_constituents(political_campaign_id)
	end
end
