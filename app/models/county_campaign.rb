class CountyCampaign < PoliticalCampaign

	#===== ASSOCIATONS =====
	has_one :county

	#===== VALIDATIONS =====
	validates_presence_of :county_id
	validates_presence_of :hd, :if => Proc.new { |c| c.seat_type == 'State House' }

	#===== EVENTS ======
	def before_validation
		self.sd = nil if self.sd.blank?
		self.hd = nil if self.hd.blank?
		self.countywide = false
		self.muniwide = false
		true
	end
	
	#===== CLASS METHODS =====
	def self.create_from_political_campaign(political_campaign)
		StateCampaign.new(:candidate_name => political_campaign.candidate_name,
			:seat_sought => political_campaign.seat_sought, 	
			:state_id => political_campaign.state_id,
			:seat_type => political_campaign.seat_type,
			:sd => political_campaign.sd,
			:hd => political_campaign.hd)
	end
end

