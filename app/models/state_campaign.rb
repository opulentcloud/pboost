class StateCampaign < PoliticalCampaign

	SEAT_TYPES = [
		#Displayed				stored in db
		[ "State Senate",					"State Senate" ],
		[ "State House",					"State House" ]
	]

	#===== ASSOCIATIONS =====
	belongs_to :senate_district
	belongs_to :house_district

	#===== VALIDATIONS =====
	validates_presence_of :seat_type
	validates_inclusion_of :seat_type, :in => SEAT_TYPES.map {|disp, value| value}
	validates_presence_of :senate_district_id, :if => Proc.new { |c| c.seat_type == 'State Senate' }
	validates_presence_of :house_district_id, :if => Proc.new { |c| c.seat_type == 'State House' }
	
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

