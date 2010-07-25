class GisRegion < ActiveRecord::Base
	acts_as_geom :geom => :polygon
	attr_accessor :vertices

	#===== SCOPES ======
	default_scope :order => 'gis_regions.name'
	named_scope :populated, :conditions => 'gis_regions.populated = true'
		
	#===== VALIDATIONS ======
	validates_presence_of :name#, :geom2#, :political_campaign_id

	#===== ASSOCIATIONS =====
	belongs_to :political_campaign
	belongs_to :contact_list
	has_and_belongs_to_many :addresses
	has_and_belongs_to_many :voters

	#===== EVENTS =====
	def before_save
		self.political_campaign_id = self.contact_list.political_campaign_id
		true
	end
	
	def	before_validation
		self.vertices = nil if self.vertices == "[]"
		return true if self.vertices.blank?
		a = instance_eval(self.vertices)
		self.geom = Polygon.from_coordinates([a[0]])
		
		polys = []
		a.each do |polygon|				
			polys.push(Polygon.from_coordinates([polygon]))
		end
		
		self.geom2 = MultiPolygon.from_polygons(polys)
		self.vertices = nil
		true
	end
	
	def before_destroy
		return if self.new_record?
		sql = "DELETE FROM addresses_gis_regions WHERE gis_region_id = #{self.id}"
		ActiveRecord::Base.connection.execute(sql)
				
		#unlink any voters from this region
		sql = "DELETE FROM gis_regions_voters WHERE gis_region_id = #{self.id}"
		ActiveRecord::Base.connection.execute(sql)
	end

	#===== INSTANCE METHODS ======
	def potential_voters_count(filters)

		sql = ''

		sql1_header = <<-eot
					SELECT COUNT(*)
					FROM  
						"constituent_addresses", "addresses", "voters"
					WHERE 
						("constituent_addresses"."political_campaign_id" = #{political_campaign.id}) 
						AND "addresses"."id" = "constituent_addresses"."address_id"
						AND "voters"."address_id" = "addresses"."id"
					AND 
						("addresses"."geom" && '#{self.geom.as_hex_ewkb}' ) 
				 AND 
						ST_contains('#{self.geom.as_hex_ewkb}', "addresses"."geom"::geometry) 
				eot

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
	
	def print_report
		self.addresses.report_table(:all, :only => [:state, :city], :methods => :full_street_address, :order => 'state, city, street_name, street_prefix, street_no, street_no_half, street_type, street_suffix, apt_type, apt_no',
		:include => { :voters => { :only => [:last_name, :first_name, :sex, :age, :party], :order => 'last_name, first_name' } },
		:group => 'id, state, city, street_name, street_prefix, street_no, street_no_half, street_type, street_suffix, apt_type, apt_no, zip5, zip4, county_name, precinct_name, precinct_code, cd, sd, hd, comm_dist_code, lat, lng, geom, geo_failed, address_hash, addresses.created_at, addresses.updated_at')
	end

	def to_vertices_array
		self.geom.first.map { |g| [g.x, g.y]}
		#r = []
		#a = self.geom.text_representation.gsub(')','').gsub('(','').split(',')
		#a.each do |s|
		#	r.push(s.split(' '))
		#end
		#r
	end

	#===== CLASS METHODS ======
	def self.to_vertices_array(poly)
		poly.first.map { |g| [g.x, g.y]}
		#r = []
		#a = self.geom.text_representation.gsub(')','').gsub('(','').split(',')
		#a.each do |s|
		#	r.push(s.split(' '))
		#end
		#r
	end

	def self.populate_all_addresses_within(gis_region_id)
		gis_region = GisRegion.find(gis_region_id)

		if gis_region.nil?
			raise ActiveRecord::RecordNotFound
		end

		political_campaign = gis_region.political_campaign
	
		#unlink any addresses from this region
		sql = "DELETE FROM addresses_gis_regions WHERE gis_region_id = #{gis_region.id}"
		sql_result = ActiveRecord::Base.connection.execute(sql)
				
		#unlink any voters from this region
		sql = "DELETE FROM gis_regions_voters WHERE gis_region_id = #{gis_region.id}"
		sql_result = ActiveRecord::Base.connection.execute(sql)

		#query using postgis db functions so we don't have
		#to loop all addresses in ruby and ask the poly if they exist
		#inside of it...much FASTER...
		sql1_header = <<-eot
					INSERT INTO addresses_gis_regions
					SELECT	"addresses"."id", "gis_regions"."id", now() as created_at, now() as updated_at 
					FROM  
						"constituent_addresses", "addresses", "gis_regions" 
					WHERE 
						("constituent_addresses"."political_campaign_id" = #{political_campaign.id}) 
						AND "addresses"."id" = "constituent_addresses"."address_id"
						AND ("gis_regions"."id" = #{gis_region.id}) 
					AND 
						("addresses"."geom" && '#{gis_region.geom2.as_hex_ewkb}' ) 
				 AND 
						ST_contains("gis_regions"."geom2", "addresses"."geom"::geometry)
				eot

		sql2_header = <<-eot
					INSERT INTO gis_regions_voters
					SELECT	#{gis_region.id} AS gis_region_id, "voters"."id", now() as created_at, now() as updated_at 
					FROM  
						"addresses_gis_regions", "voters" 
					WHERE 
						"addresses_gis_regions"."gis_region_id" = #{gis_region.id}
						AND "voters"."address_id" = "addresses_gis_regions"."address_id"
				eot

		sql1 = sql1_header
		sql_result = ActiveRecord::Base.connection.execute(sql1)

		sql2 = sql2_header
		sql_result = ActiveRecord::Base.connection.execute(sql2)

		#more old code
		if 1 == 0						
			Address.find_by_sql(sql).each do |address|
				begin
					gis_region.addresses << address 
				rescue ActiveRecord::StatementInvalid => err
					if !err.message =~ /duplicate/
						err.raise
					end
				end
				begin
					gis_region.voters << address.voters
				rescue ActiveRecord::StatementInvalid => err
					if !err.message =~ /duplicate/
						err.raise
					end
				end
			end
		end

		#old code
		if 1 == 0
		#find all the addresses within the bbox of this polygon
		Address.find_all_by_geom_and_state(gis_region.geom, gis_region.political_campaign.state.abbrev).each do |address|
			#now we must ask each address by point if it is inside the polygon
			if gis_region.contains?(address.geom)
				begin
					gis_region.addresses << address 
				rescue ActiveRecord::StatementInvalid => err
					if !err.message =~ /duplicate/
						err.raise
					end
				end
				begin
					gis_region.voters << address.voters
				rescue ActiveRecord::StatementInvalid => err
					if !err.message =~ /duplicate/
						err.raise
					end
				end
			end
		end
		end #old code
		
		gis_region.voter_count = gis_region.voters.count
		gis_region.populated = true
		gis_region.save!
		logger.debug(gis_region.addresses.count)
		logger.debug(gis_region.voters.count)
	end

	def self.coordinates_from_text(text_coords)
 		text_coords.scan(/[\d\-\.]+/ ).map{|v| v.to_f }.in_groups_of(2)
		
#		r = []
#		ary = text_coords.to_s.split(',')

#		for x in 0.step(ary.size-1,2)
#			a1 = ary[x].to_s.gsub(/\[|\]/, '').to_f
#			a2 = ary[x+1].to_s.gsub(/\[|\]/, '').to_f
#			r.push([a1, a2])
#		end
#		r
	end

private
	#===== PRIVATE INSTANCE METHODS =====
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
		
end
