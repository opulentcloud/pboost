class PoliticalCampaign < ActiveRecord::Base

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

	#==== VALIDATIONS ====
	validates_presence_of :candidate_name, :seat_sought, :state_abbrev, :type

end
