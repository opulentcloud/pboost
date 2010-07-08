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

	#===== PROPERTIES ======
	def precincts
		if self.congressional_district
			self.congressional_district.precincts
		else
			self.state.precincts
		end	
	end
	
	def lat
		self.state.lat
	end
	
	def lng
		self.state.lng
	end

	def campaign_description

		if !congressional_district_id.blank?
			begin
				i = Integer(congressional_district.cd.gsub(/^0+/,''))
				"#{candidate_name} for #{seat_sought} #{congressional_district.cd.to_i.ordinalize} Congressional District State of #{state.name}".strip
			rescue
				"#{candidate_name} for #{seat_sought} Congressional District #{house_district.hd} State of #{state.name}".strip
			end
		else
			"#{candidate_name} for #{seat_sought} State of #{state.name}".strip
		end
	end
	
	#===== CLASS METHODS =====
	def self.create_from_political_campaign(political_campaign)
		FederalCampaign.new(:candidate_name => political_campaign.candidate_name,
			:seat_sought => political_campaign.seat_sought, 	
			:state_id => political_campaign.state_id,
			:seat_type => political_campaign.seat_type,
			:congressional_district_id => political_campaign.congressional_district_id)
	end
end
