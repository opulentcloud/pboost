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

	def populate_all_addresses_within
		#remove all addresses that may exist
		self.addresses.destroy_all
		#remove all voters that may exist
		self.voters.destroy_all

		#find all the addresses within the bbox of this polygon
		addresses = Address.find_all_by_geom(self.geom)
		#now we must ask each address by point if it is inside the polygon
		addresses.each do |address|
			if self.contains?(address.geom)
				begin
					self.addresses << address 
				rescue ActiveRecord::StatementInvalid => err
					if !err.message =~ /duplicate/
						err.raise
					end
				end
				begin
					self.voters << address.voters
				rescue ActiveRecord::StatementInvalid => err
					if !err.message =~ /duplicate/
						err.raise
					end
				end
			end
		end
		puts self.addresses.count
	end


	#===== CLASS METHODS ======
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
