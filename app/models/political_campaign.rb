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

end
