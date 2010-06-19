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
	has_many :gis_regions, :dependent => :destroy
	has_many :walksheets, :dependent => :destroy
	has_many :constituents#, :dependent => :destroy
	has_many :voters, :through => :constituents
	has_many :constituent_addresses#, :dependent => :destroy
	has_many :addresses, :through => :constituent_addresses

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

	def before_destroy
		return if self.new_record?
		sql = "DELETE FROM constituent_addresses WHERE political_campaign_id = #{self.id}"
		ActiveRecord::Base.connection.execute(sql)
				
		sql = "DELETE FROM constituents WHERE political_campaign_id = #{self.id}"
		ActiveRecord::Base.connection.execute(sql)
	end

	#==== PROPERTIES =====
	attr_accessor :city_text

	def lat
		case self.type
		when 'FederalCampaign' then FederalCampaign.find(self.id).lat
		when 'StateCampaign' then StateCampaign.find(self.id).lat
		when 'CountyCampaign' then CountyCampaign.find(self.id).lat
		when 'MunicipalCampaign' then MunicipalCampagin.find(self.id).lat
		end
	end

	def lng
		case self.type
		when 'FederalCampaign' then FederalCampaign.find(self.id).lng
		when 'StateCampaign' then StateCampaign.find(self.id).lng
		when 'CountyCampaign' then CountyCampaign.find(self.id).lng
		when 'MunicipalCampaign' then MunicipalCampagin.find(self.id).lng
		end
	end

	#===== CLASS METHODS =====
	def self.populate_constituents(political_campaign_id)

		political_campaign = PoliticalCampaign.find(political_campaign_id)

		if political_campaign.nil?
			raise ActiveRecord::RecordNotFound
		end

		#unlink any addresses from this campaign
		sql = "DELETE FROM constituent_addresses WHERE political_campaign_id = #{political_campaign.id}"
		sql_result = ActiveRecord::Base.connection.execute(sql)
				
		#unlink any voters from this campaign
		sql = "DELETE FROM constituents WHERE political_campaign_id = #{political_campaign.id}"
		sql_result = ActiveRecord::Base.connection.execute(sql)

		#send custom query to server to populate 
		#constituents and constituent_addresses
		sql1_header = <<-eot
					INSERT INTO constituent_addresses
					SELECT nextval('constituent_addresses_id_seq') AS id, 
						#{political_campaign_id} AS political_campaign_id,	"addresses"."id" AS address_id, now() AS created_at, now() AS updated_at 
					FROM  
						"addresses"
					WHERE 
						("addresses"."state" = '#{political_campaign.state.abbrev}') 
				eot

		sql2_header = <<-eot
					INSERT INTO constituents
					SELECT nextval('constituents_id_seq') AS id, 
					#{political_campaign_id} AS political_campaign_id, "voters"."id" AS voter_id, now() AS created_at, now() AS updated_at 
					FROM  
						"constituent_addresses", "voters" 
					WHERE 
						("constituent_addresses"."political_campaign_id" = #{political_campaign_id}) 
						AND ("voters"."address_id" = "constituent_addresses"."address_id") 
				eot

			sql = ''

			if political_campaign.class.to_s == 'FederalCampaign'
						
				if political_campaign.congressional_district
					sql += <<-eot
						AND 
							("addresses"."cd" = '#{political_campaign.congressional_district.cd}') 
					eot
				end

			end

			if political_campaign.class.to_s == 'StateCampaign'

				if political_campaign.senate_district
					sql += <<-eot
						 AND 
						("addresses"."sd" = '#{political_campaign.senate_district.sd}') 
					eot
				end

				if political_campaign.house_district
					sql += <<-eot
						 AND 
							("addresses"."hd" = '#{political_campaign.house_district.hd}') 
					eot
				end

			end

			if political_campaign.class.to_s == 'CountyCampaign'
			
				if political_campaign.county
					sql += <<-eot
						 AND 
							("addresses"."county_name" = '#{political_campaign.county.name}') 
					eot

					if political_campaign.council_district
						sql += <<-eot 
							AND 
								("addresses"."comm_dist_code" = '#{political_campaign.council_district.code}') 
						eot
					end

				end

			end
#debugger
			if political_campaign.class.to_s == 'MunicipalCampaign'

				if political_campaign.city
					sql += <<-eot
						 AND 
							("addresses"."city" = '#{political_campaign.city.name}') 
					eot

					if political_campaign.municipal_district
						sql += <<-eot
							 AND 
								("addresses"."mcomm_dist_code" = '#{political_campaign.municipal_district.code}') 
						eot
					end

				end

			end

		sql1 = sql1_header + sql
		sql_result = ActiveRecord::Base.connection.execute(sql1)

		sql2 = sql2_header
		
		sql_result = ActiveRecord::Base.connection.execute(sql2)

		political_campaign.constituent_count = political_campaign.constituents.count
		political_campaign.populated = true
		political_campaign.save!
	end
	
end
