class MunicipalCampaign < PoliticalCampaign

	#===== ASSOCIATONS =====
	has_one :city

	#===== VALIDATIONS =====
	validates_presence_of :city_id, :message => 'City is not valid'
	validates_inclusion_of :muniwide, :in => [true, false], :message => 'Please choose yes or no'
	validates_presence_of :municipal_district_id, :if => :require_municipal_district?

	#===== INSTANCE METHODS =====	
	def require_municipal_district?
		begin
			c = City.find(self.city_id)
		rescue ActiveRecord::RecordNotFound
			return false
		end
		c.municipal_districts.count > 0
	end
	
	#===== CLASS METHODS =====
	def self.create_from_political_campaign(political_campaign)
		MunicipalCampaign.new(:candidate_name => political_campaign.candidate_name,
			:seat_sought => political_campaign.seat_sought, 	
			:state_id => political_campaign.state_id,
			:seat_type => political_campaign.seat_type,
			:city_text => political_campaign.city_text,
			:muniwide => political_campaign.muniwide,
			:municipal_district_id => political_campaign.municipal_district_id)
	end
end

