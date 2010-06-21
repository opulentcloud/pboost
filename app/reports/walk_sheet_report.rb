class WalkSheetReport < Ruport::Controller

	stage :list
	
	def setup
		options.paper_orientation = :landscape
		conditions = ["walksheet.id = ?", options.walksheet]
		self.data = Walksheet.find(options.walksheet).addresses.report_table(:all, 
 :methods => :full_street_address, 
	:include => { :voters => { :only => [:last_name, :first_name, :sex, :age, :party], :order => 'last_name, first_name' } },		
 :only => ['full_street_address', 'voters.last_name', 'voters.first_name', 'voters.age', 'voters.sex', 'voters.party'], 
 :order => 'state, city, street_name, street_prefix, is_odd, street_no, street_no_half, street_type, street_suffix, apt_type, apt_no',
		:group => 'addresses.id, state, city, street_name, street_prefix, is_odd, street_no, street_no_half, street_type, street_suffix, apt_type, apt_no, zip5, zip4, county_name, precinct_name, precinct_code, cd, sd, hd, comm_dist_code, mcomm_dist_code, lat, lng, geom, geo_failed, address_hash, addresses.created_at, addresses.updated_at')
	
		data.rename_columns('state' => 'ST', 'city' => 'City', 'full_street_address' => 'Address', 'voters.sex' => 'Sex', 'voters.party' => 'Party', 'voters.age' => 'Age', 'voters.last_name' => 'Last Name', 'voters.first_name' => 'First Name')


	end

	formatter :html do
		build :list do
			output << "<h2>Walk Sheet</h2>"
			output << data.to_html
		end
	end

	formatter :pdf do
		build :list do
			pad(5) { add_text "Walk Sheet" }
			draw_table data
		end
	end

	formatter :csv do
		build :list do
			output << data.to_csv
		end
	end
end
