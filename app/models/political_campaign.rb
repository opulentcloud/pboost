class PoliticalCampaign < ActiveRecord::Base

	#===== MAPPED VALUES ======
	POLITICAL_CAMPAIGN_TYPES = [
		#Displayed				stored in db
		[ "Federal",			"FederalCampaign" ],
		[ "State",				"StateCampaign" ],
		[ "County",				"CountyCampaign" ],
		[ "Municipal",		"MunicipalCampaign" ]
	]

	FEDERAL_SEAT_TYPES = [
		#Displayed				stored in db
		[ "U.S. Senate",					"U.S. Senate" ],
		[ "U.S. Congress",				"U.S. Congress"]
	]

	STATE_SEAT_TYPES = [
		#Displayed				stored in db
		[ "State Senate",					"State Senate" ],
		[ "State House",					"State House" ]
	]

	#==== ASSOCIATIONS ====
	belongs_to :organization
	has_many :users, :through => :organization

	#==== VALIDATIONS ====
	validates_presence_of :candidate_name, :seat_sought, :state_abbrev, :type
	validates_presence_of :seat_type, :if => Proc.new { |c| ['FederalCampaign', 'StateCampaign'].include?(c.type) }
	validates_inclusion_of :seat_type, :in => FEDERAL_SEAT_TYPES.map {|disp, value| value}, :if => Proc.new { |c| c.type == 'FederalCampaign' }
	validates_inclusion_of :seat_type, :in => STATE_SEAT_TYPES.map {|disp, value| value}, :if => Proc.new { |c| c.type == 'StateCampaign' }
	validates_presence_of :cd, :if => Proc.new { |c| c.seat_type == 'U.S. Congress' }
	validates_presence_of :sd, :if => Proc.new { |c| c.seat_type == 'State Senate' }, :message => 'State Senate District is required'
	validates_presence_of :hd, :if => Proc.new { |c| c.seat_type == 'State House' }, :message => 'State House District is required'

	#===== EVENTS ======
	def before_validation
		self.cd = nil if self.cd.blank?
		self.sd = nil if self.sd.blank?
		self.hd = nil if self.hd.blank?
		self.countywide = false if ['FederalCampaign', 'StateCampaign'].include?(self.type)
		self.muniwide = false if ['FederalCampaign', 'StateCampaign'].include?(self.type)
	end

end
