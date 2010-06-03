class CountyCampaign < PoliticalCampaign

	#===== ASSOCIATONS =====
	has_one :county

	#===== VALIDATIONS =====
	validates_presence_of :county_id
	validates_presence_of :countywide
	validates_presence_of :council_district_id, :if => Proc.new { |c| c.countywide == false }
	
	#===== CLASS METHODS =====
	def self.create_from_political_campaign(political_campaign)
		CountyCampaign.new(:candidate_name => political_campaign.candidate_name,
			:seat_sought => political_campaign.seat_sought, 	
			:state_id => political_campaign.state_id,
			:seat_type => political_campaign.seat_type,
			:county_id => political_campaign.county_id,
			:countywide => political_campaign.countywide,
			:council_district_id => political_campaign.council_district_id)
	end
end

