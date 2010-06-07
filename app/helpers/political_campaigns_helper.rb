module PoliticalCampaignsHelper

	def get_edit_political_campaign_path(political_campaign)
		case political_campaign.type
		when 'FederalCampaign' then edit_federal_campaign_url(political_campaign.id)
		when 'StateCampaign' then edit_state_campaign_url(political_campaign.id)
		when 'CountyCampaign' then edit_county_campaign_url(political_campaign.id)
		when 'MunicipalCampaign' then edit_municipal_campaign_url(political_campaign.id)
		end

	end
	
end
