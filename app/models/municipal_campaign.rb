class MunicipalCampaign < PoliticalCampaign

	#===== ASSOCIATONS =====
	has_one :city

	#===== VALIDATIONS =====
	validates_presence_of :city_id, :message => 'City is not valid'
	validates_inclusion_of :muniwide, :in => [true, false], :message => 'Please choose yes or no'
	
	#===== CLASS METHODS =====
	def self.create_from_political_campaign(political_campaign)
		MunicipalCampaign.new(:candidate_name => political_campaign.candidate_name,
			:seat_sought => political_campaign.seat_sought, 	
			:state_id => political_campaign.state_id,
			:seat_type => political_campaign.seat_type,
			:city_text => political_campaign.city_text,
			:muniwide => political_campaign.muniwide)
	end
end

