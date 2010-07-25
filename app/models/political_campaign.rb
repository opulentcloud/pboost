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
	has_many :contact_lists
	has_many :walksheets, :dependent => :destroy
	has_many :sms_lists, :dependent => :destroy
	has_many :constituents#, :dependent => :destroy
	has_many :voters, :through => :constituents
	has_many :constituent_addresses#, :dependent => :destroy
	has_many :addresses, :through => :constituent_addresses

	#==== VALIDATIONS ====
	validates_presence_of :candidate_name, :seat_sought, :state_id, :type

	#===== EVENTS ======
	def before_validation
		self.repopulate = true if (self.repopulate == "1")
	
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

	def before_save
		if self.repopulate == true
			self.constituent_count = 0
			self.populated = false
		end
		true
	end

	def before_destroy
		return if self.new_record?
		sql = "DELETE FROM constituent_addresses WHERE political_campaign_id = #{self.id}"
		ActiveRecord::Base.connection.execute(sql)
				
		sql = "DELETE FROM constituents WHERE political_campaign_id = #{self.id}"
		ActiveRecord::Base.connection.execute(sql)
	end

	#==== ACCESSORS =====
	attr_accessor_with_default :repopulate, false
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

	#===== INSTANCE METHODS ======
	def potential_voters_count(filters)

		sql = ''

		sql1_header = <<-eot
					SELECT COUNT(*)
					FROM  
						"constituent_addresses", "addresses", "voters"
					WHERE 
						("constituent_addresses"."political_campaign_id" = #{self.id}) 
						AND "addresses"."id" = "constituent_addresses"."address_id"
						AND "voters"."address_id" = "addresses"."id"
				eot

			if filters.has_key?(:geom) && !filters[:geom].blank?
					sql += <<-eot
					AND 
						("addresses"."geom" && '#{filters[:geom]}' ) 
				 AND 
						ST_contains('#{filters[:geom]}', "addresses"."geom"::geometry) 
					eot
			elsif filters.has_key?(:precinct_code)
				sql += <<-eot
					AND ("addresses"."precinct_code" = '#{filters[:precinct_code]}') 
				eot
			end

			if filters.has_key?(:min_age) && filters.has_key?(:max_age)
				sql += <<-eot
					AND
						("voters"."age" BETWEEN #{filters[:min_age]} AND #{filters[:max_age]})
				eot
			end

			if filters.has_key?(:sex)
				sql += <<-eot
					AND
						("voters"."sex" = '#{filters[:sex]}')
				eot
			end

			if filters.has_key?(:party_filters)
				@in = []
				filters[:party_filters].split(',').each do |f|
					@in.push(Party.find(f.to_i).code)
				end

				sql += <<-eot
					AND
						("voters"."party" IN ('#{@in.join(',')}'))
				eot
			end

			if filters.has_key?(:voting_history_filters) && filters[:voting_history_filters].size > 0
				sql += case filters[:filter_type]
					when 'Any' then build_any_voting_history_query(filters)
					when 'All' then build_all_voting_history_query(filters)
					when 'At Least' then build_at_least_voting_history_query(filters)
					when 'Exactly' then build_exactly_voting_history_query(filters)
					when 'No More Than' then build_no_more_than_voting_history_query(filters)
				end
			end

		if filters.has_key?(:list_type)
			if filters[:list_type] == 'sms_list'
				sql += <<-eot
				AND ("voters"."cell_phone" != '') 
				eot
			end
		end

#debugger
		sql1 = sql1_header + sql + ';'
		sql_result = ActiveRecord::Base.connection.execute(sql1)
		sql_result.first[0].to_i
	end

	def build_any_voting_history_query(filters)
		sql = 'AND ('
		query_type = nil

		filters[:voting_history_filters].each do |e|
			vt = VotingHistoryFilter::VOTING_TYPES.map { |disp,value| [disp,value] }.to_a

			vt.each do |a|
				if a[0] == e.query_vote_type
					query_type = a[1]
					break
				end
			end
			
			case query_type
				when 'Voted' then
					sql += "EXISTS (SELECT * FROM \"voting_history_voters\" WHERE \"voting_history_voters\".\"voter_id\" = \"voters\".\"id\" AND \"voting_history_voters\".\"election_year\" = #{e.year} AND \"voting_history_voters\".\"election_type\" = '#{e.election_type}') OR "
				when 'Didn\'t Vote' then
					sql += "NOT EXISTS (SELECT * FROM \"voting_history_voters\" WHERE \"voting_history_voters\".\"voter_id\" = \"voters\".\"id\" AND \"voting_history_voters\".\"election_year\" = #{e.year} AND \"voting_history_voters\".\"election_type\" = '#{e.election_type}') OR "
				else
					sql += "EXISTS (SELECT * FROM \"voting_history_voters\" WHERE \"voting_history_voters\".\"voter_id\" = \"voters\".\"id\" AND \"voting_history_voters\".\"election_year\" = #{e.year} AND \"voting_history_voters\".\"election_type\" = '#{e.election_type}' AND \"voting_history_voters\".\"voter_type\" = '#{query_type}' ) OR "
			end
		end

		sql = sql[0,sql.length-4]
		sql += ')'
	end

	def build_all_voting_history_query(filters)
		sql = build_any_voting_history_query(filters)
		sql.gsub(' OR ', ' AND ')
	end

	def build_x_limit_query(filters)
		sql = 'AND ('
		query_type = nil

		filters[:voting_history_filters].each do |e|
			vt = VotingHistoryFilter::VOTING_TYPES.map { |disp,value| [disp,value] }.to_a

			vt.each do |a|
				if a[0] == e.query_vote_type
					query_type = a[1]
					break
				end
			end
			
			case query_type
				when 'Voted' then
					sql += "(SELECT COUNT(*) FROM \"voting_history_voters\" WHERE \"voting_history_voters\".\"voter_id\" = \"voters\".\"id\" AND \"voting_history_voters\".\"election_year\" = #{e.year} AND \"voting_history_voters\".\"election_type\" = '#{e.election_type}') + "
				when 'Didn\'t Vote' then
					sql += "CASE (SELECT COUNT(*) FROM \"voting_history_voters\" WHERE \"voting_history_voters\".\"voter_id\" = \"voters\".\"id\" AND \"voting_history_voters\".\"election_year\" = #{e.year} AND \"voting_history_voters\".\"election_type\" = '#{e.election_type}') WHEN 0 THEN 1 ELSE 0 END + "
				else
					sql += "(SELECT COUNT(*) FROM \"voting_history_voters\" WHERE \"voting_history_voters\".\"voter_id\" = \"voters\".\"id\" AND \"voting_history_voters\".\"election_year\" = #{e.year} AND \"voting_history_voters\".\"election_type\" = '#{e.election_type}' AND \"voting_history_voters\".\"voter_type\" = '#{query_type}' ) + "
			end
		end

		sql = sql[0,sql.length-3]
	
	end

	def build_no_more_than_voting_history_query(filters)
		sql = build_x_limit_query(filters)
		sql += " <= #{filters[:filter_type_int_val]})"
	end

	def build_exactly_voting_history_query(filters)
		sql = build_x_limit_query(filters)
		sql += " = #{filters[:filter_type_int_val]})"
	end

	def build_at_least_voting_history_query(filters)
		sql = build_x_limit_query(filters)
		sql += " >= #{filters[:filter_type_int_val]})"
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
		political_campaign.repopulate = false
		political_campaign.save!
	end
	
end
