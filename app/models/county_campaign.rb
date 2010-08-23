class CountyCampaign < PoliticalCampaign

	#===== ASSOCIATONS =====
	belongs_to :county
	belongs_to :council_district

	#===== VALIDATIONS =====
	validates_presence_of :county_id
	validates_inclusion_of :countywide, :in => [true, false], :message => 'Please choose yes or no'
	validates_presence_of :council_district_id, :if => :require_council_district?
	#validates_presence_of :council_district_id, :if => Proc.new { |c| c.countywide == false }

	#===== PROPERTIES ======
	def precincts
		if self.council_district
			self.council_district.precincts(:conditions => { :county_id => "#{self.county_id}" }) 
		else
			self.county.precincts
		end
	end
	
	def lat
		self.county.lat
	end
	
	def lng
		self.county.lng
	end

	def campaign_description
		if council_district_id.blank?
			"#{candidate_name} for #{seat_sought} #{county.name}".strip
		else
			begin
				i = Integer(council_district.code.gsub(/^0+/,''))
				"#{candidate_name} for #{seat_sought} #{county.name} County #{council_district.code.to_i.ordinalize} District".strip
			rescue
				"#{candidate_name} for #{seat_sought} #{county.name} County District #{council_district.code}".strip
			end
		end
	end

	#===== INSTANCE METHODS =====	
	def require_council_district?
		return false if self.countywide
		begin
			c = County.find(self.county_id)
			return false if c.nil?
			c.council_districts.count > 0
		rescue ActiveRecord::RecordNotFound
			errors.add_to_base('County is required.')
			false
		end
	end

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

