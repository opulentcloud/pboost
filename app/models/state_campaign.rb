class StateCampaign < PoliticalCampaign

	SEAT_TYPES = [
		#Displayed				stored in db
		[ "Attorney General",			"Attorney General" ],
		[ "Comptroller",					"Comptroller" ],
		[ "Governor",							"Governor" ],
		[ "Lt. Governor",					"Lt. Governor" ],
		[ "State House",					"State House" ],
		[ "State Senate",					"State Senate" ]
	]

	#===== ASSOCIATIONS =====
	belongs_to :senate_district
	belongs_to :house_district

	#===== VALIDATIONS =====
	validates_presence_of :seat_type
	validates_inclusion_of :seat_type, :in => SEAT_TYPES.map {|disp, value| value}
	validates_presence_of :senate_district_id, :if => Proc.new { |c| c.seat_type == 'State Senate' }
	validates_presence_of :house_district_id, :if => Proc.new { |c| c.seat_type == 'State House' }

	#===== PROPERTIES ======
	def council_districts
		if self.house_district
			self.house_district.council_districts
		elsif self.senate_district
			self.senate_district.council_districts
		else
			self.state.council_districts
		end							
	end

	def precincts
		if self.house_district
			self.house_district.precincts(:conditions => { :house_district_id => "#{self.house_district_id}" })
		elsif self.senate_district
			self.senate_district.precincts(:conditions => { :senate_district_id => "#{self.senate_district_id}" })
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

		if !house_district_id.blank?
			begin
				i = Integer(house_district.hd.gsub(/^0+/,''))
				"#{candidate_name} for #{seat_sought} #{house_district.hd.to_i.ordinalize} District".strip
			rescue
				"#{candidate_name} for #{seat_sought} District #{house_district.hd}".strip
			end
		elsif !senate_district_id.blank?
			begin
				i = Integer(senate_district.sd.gsub(/^0+/,''))
				"#{candidate_name} for #{seat_sought} #{senate_district.sd.to_i.ordinalize} District".strip
			rescue
				"#{candidate_name} for #{seat_sought} District #{senate_district.sd}".strip
			end
		else
			"#{candidate_name} for #{seat_sought}".strip
		end
	end
	
	#===== CLASS METHODS =====
	def self.create_from_political_campaign(political_campaign)
		StateCampaign.new(:candidate_name => political_campaign.candidate_name,
			:seat_sought => political_campaign.seat_sought, 	
			:state_id => political_campaign.state_id,
			:seat_type => political_campaign.seat_type,
			:senate_district_id => political_campaign.senate_district_id,
			:house_district_id => political_campaign.house_district_id)
	end
end

