class StateCampaign < PoliticalCampaign

	SEAT_TYPES = [
		#Displayed				stored in db
		[ "State Senate",					"State Senate" ],
		[ "State House",					"State House" ]
	]

	#===== VALIDATIONS =====
	validates_presence_of :seat_type
	validates_inclusion_of :seat_type, :in => SEAT_TYPES.map {|disp, value| value}
	validates_presence_of :sd, :if => Proc.new { |c| c.seat_type == 'State Senate' }
	validates_presence_of :hd, :if => Proc.new { |c| c.seat_type == 'State House' }

	#===== EVENTS ======
	def before_validation
		self.sd = nil if self.sd.blank?
		self.hd = nil if self.hd.blank?
		self.countywide = false
		self.muniwide = false
	end
	
	#===== CLASS METHODS =====
	def self.create_from_political_campaign(political_campaign)
		StateCampaign.new(:candidate_name => political_campaign.candidate_name,
			:seat_sought => political_campaign.seat_sought, 	
			:state_abbrev => political_campaign.state_abbrev,
			:seat_type => political_campaign.seat_type,
			:sd => political_campaign.sd,
			:hd => political_campaign.hd)
	end
end

