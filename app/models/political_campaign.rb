class PoliticalCampaign < ActiveRecord::Base

	#===== MAPPED VALUES ======
	POLITICAL_CAMPAIGN_TYPES = [
		#Displayed				stored in db
		[ "Federal",			"FederalCampaign" ],
		[ "State",				"StateCampaign" ],
		[ "County",				"CountyCampaign" ],
		[ "Municipal",		"MunicipalCampaign" ]
	]

	#==== PROPERTIES =====
	attr_accessor :city_text

	#==== ASSOCIATIONS ====
	belongs_to :organization
	has_many :users, :through => :organization
	belongs_to :state
	has_many :gis_regions

	#==== VALIDATIONS ====
	validates_presence_of :candidate_name, :seat_sought, :state_id, :type

	#===== EVENTS ======
	def before_validation
		if self.type == 'FederalCampaign'
			self.seat_sought = self.seat_type
		elsif self.type == 'StateCampaign'
			self.seat_sought = "#{self.state.name} #{self.seat_type}"
		end
	
		if !self.city_text.blank?
			self.city_id = City.find_by_name(self.city_text)
		end

		self.congressional_district_id == nil if self.congressional_district_id.blank? || self.seat_type != 'U.S. Congress'
		self.senate_district_id = nil if self.senate_district_id.blank? || self.seat_type != 'State Senate'
		self.house_district_id = nil if self.house_district_id.blank? || self.seat_type != 'State House'
		self.county_id = nil if self.county_id.blank? || self.type != 'CountyCampaign'
		self.countywide = false if self.type != 'CountyCampaign'
		self.council_district_id = nil if (self.council_district_id.blank? || self.type != 'CountyCampaign' || self.countywide == true)
		self.muniwide = false if self.type != 'MunicipalCampaign'
		self.city_id = nil if self.city_id.blank? || self.type != 'MunicipalCampaign'
		self.municipal_district_id = nil if (self.municipal_district_id.blank? || self.type != 'MunicipalCampaign' || self.muniwide == true)
		true
	end

end
