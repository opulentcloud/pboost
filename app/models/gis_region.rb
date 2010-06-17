class GisRegion < ActiveRecord::Base
	acts_as_geom :geom => :polygon
	acts_as_reportable

	#===== SCOPES ======
	default_scope :order => 'gis_regions.name'
		
	#===== VALIDATIONS ======
	validates_presence_of :name, :geom, :political_campaign_id

	#===== ASSOCIATIONS =====
	belongs_to :political_campaign
	has_and_belongs_to_many :addresses
	has_and_belongs_to_many :voters

	#===== EVENTS =====
	def before_destroy
		sql = "DELETE FROM addresses_gis_regions WHERE gis_region_id = #{self.id}"
		ActiveRecord::Base.connection.execute(sql)
				
		#unlink any voters from this region
		sql = "DELETE FROM gis_regions_voters WHERE gis_region_id = #{self.id}"
		ActiveRecord::Base.connection.execute(sql)
	end

	#===== INSTANCE METHODS ======
	def print_report
		self.addresses.report_table(:all, :only => [:state, :city], :methods => :full_street_address, :order => 'state, city, street_name, street_prefix, street_no, street_no_half, street_type, street_suffix, apt_type, apt_no',
		:include => { :voters => { :only => [:last_name, :first_name, :sex, :age, :party], :order => 'last_name, first_name' } },
		:group => 'id, state, city, street_name, street_prefix, street_no, street_no_half, street_type, street_suffix, apt_type, apt_no, zip5, zip4, county_name, precinct_name, precinct_code, cd, sd, hd, comm_dist_code, lat, lng, geom, geo_failed, address_hash, addresses.created_at, addresses.updated_at')
	end

	def to_vertices_array
		r = []
		a = self.geom.text_representation.gsub(')','').gsub('(','').split(',')
		a.each do |s|
			r.push(s.split(' '))
		end
		r
	end

	#===== CLASS METHODS ======
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
						"addresses", "gis_regions" 
					WHERE 
						("gis_regions"."id" = #{gis_region.id}) 
					AND 
						("addresses"."geom" && '#{gis_region.geom.as_hex_ewkb}' ) 
					AND 
						("addresses"."state" = '#{political_campaign.state.abbrev}')
				eot

		sql2_header = <<-eot
					INSERT INTO gis_regions_voters
					SELECT	"gis_regions"."id", "voters"."id", now() as created_at, now() as updated_at 
					FROM  
						"addresses", "gis_regions", "voters" 
					WHERE 
						("gis_regions"."id" = #{gis_region.id}) 
					AND 
						("addresses"."geom" && '#{gis_region.geom.as_hex_ewkb}' ) 
					AND 
						("addresses"."state" = '#{political_campaign.state.abbrev}')
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

			sql += <<-eot
				 AND 
						ST_contains("gis_regions"."geom", "addresses"."geom"::geometry)
			eot

		sql1 = sql1_header + sql
		sql_result = ActiveRecord::Base.connection.execute(sql1)

		sql += <<-eot
			AND
				"voters"."address_id" = "addresses"."id"
		eot

		sql2 = sql2_header + sql
		
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
		r = []
		ary = text_coords.to_s.split(',')

		for x in 0.step(ary.size-1,2)
			a1 = ary[x].to_s.gsub(/\[|\]/, '').to_f
			a2 = ary[x+1].to_s.gsub(/\[|\]/, '').to_f
			r.push([a1, a2])
		end
		r
	end

end
