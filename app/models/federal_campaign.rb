class FederalCampaign < PoliticalCampaign

	SEAT_TYPES = [
		#Displayed				stored in db
		[ "U.S. Senate",					"U.S. Senate" ],
		[ "U.S. Congress",				"U.S. Congress"]
	]

	#===== VALIDATIONS =====
	validates_presence_of :seat_type
	validates_inclusion_of :seat_type, :in => SEAT_TYPES.map {|disp, value| value}
	validates_presence_of :cd, :if => Proc.new { |c| c.seat_type == 'U.S. Congress' }

	#===== EVENTS ======
	def before_validation
		self.cd == nil if self.cd.blank?
		self.countywide = false
		self.muniwide = false
		true
	end
	
	#===== CLASS METHODS =====
	def self.create_from_political_campaign(political_campaign)
		FederalCampaign.new(:candidate_name => political_campaign.candidate_name,
			:seat_sought => political_campaign.seat_sought, 	
			:state_abbrev => political_campaign.state_abbrev,
			:seat_type => political_campaign.seat_type,
			:cd => political_campaign.cd)
	end
end
