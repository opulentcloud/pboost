class FederalCampaign < PoliticalCampaign

	SEAT_TYPES = [
		#Displayed				stored in db
		[ "U.S. Senate",					"U.S. Senate" ],
		[ "U.S. Congress",				"U.S. Congress"]
	]

	#===== ASSOCIATIONS =====
	belongs_to :congressional_district

	#===== VALIDATIONS =====
	validates_presence_of :seat_type
	validates_inclusion_of :seat_type, :in => SEAT_TYPES.map {|disp, value| value}
	validates_presence_of :congressional_district_id, :if => Proc.new { |c| c.seat_type == 'U.S. Congress' }
	
	#===== CLASS METHODS =====
	def self.create_from_political_campaign(political_campaign)
		FederalCampaign.new(:candidate_name => political_campaign.candidate_name,
			:seat_sought => political_campaign.seat_sought, 	
			:state_id => political_campaign.state_id,
			:seat_type => political_campaign.seat_type,
			:congressional_district_id => political_campaign.congressional_district_id)
	end
end
