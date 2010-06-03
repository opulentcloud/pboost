class PoliticalCampaign < ActiveRecord::Base

	#===== MAPPED VALUES ======
	POLITICAL_CAMPAIGN_TYPES = [
		#Displayed				stored in db
		[ "Federal",			"FederalCampaign" ],
		[ "State",				"StateCampaign" ],
		[ "County",				"CountyCampaign" ],
		[ "Municipal",		"MunicipalCampaign" ]
	]

	#==== ASSOCIATIONS ====
	belongs_to :organization
	has_many :users, :through => :organization
	belongs_to :state

	#==== VALIDATIONS ====
	validates_presence_of :candidate_name, :seat_sought, :state_id, :type

	#===== EVENTS ======
	def before_validation
		self.congressional_district_id == nil if self.congressional_district_id.blank?
		self.senate_district_id = nil if self.senate_district_id.blank?
		self.house_district_id = nil if self.house_district_id.blank?
		self.council_district_id = nil if self.council_district_id.blank?
		self.countywide = false if self.type != 'CountyCampaign'
		self.muniwide = false if self.type != 'MunicipalCampaign'
		true
	end

end
