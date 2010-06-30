require 'ruby-debug'

	#==== populate the organization_types table data =====
	data = FasterCSV.read("#{RAILS_ROOT}/db/migrate/fixtures/organization_types.csv", :headers => false)
	data.each do |row|
		s = OrganizationType.find_or_create_by_name(row[0])	
	end
	#==== end populate organization_types table data ====

	#==== populate the account_types table data =====
	data = FasterCSV.read("#{RAILS_ROOT}/db/migrate/fixtures/account_types.csv", :headers => false)
	data.each do |row|
		s = AccountType.find_or_create_by_name(row[0])	
	end
	#==== end populate account_types table data ====

	#==== populate time_zones table data ===
	TimeZone.find_or_create_by_zone('Hawaii')
	TimeZone.find_or_create_by_zone('Alaska')
	TimeZone.find_or_create_by_zone('Pacific Time (US & Canada)')
	TimeZone.find_or_create_by_zone('Arizona')
	TimeZone.find_or_create_by_zone('Mountain Time (US & Canada)')
	TimeZone.find_or_create_by_zone('Central Time (US & Canada)')
	TimeZone.find_or_create_by_zone('Eastern Time (US & Canada)')
	TimeZone.find_or_create_by_zone('Indiana (East)')
	TimeZone.find_or_create_by_zone('Atlantic Time (Canada)')
	TimeZone.find_or_create_by_zone('Guam')
	#==== end populate time_zones table data ====

	#====== populate default roles =====
	data = FasterCSV.read("#{RAILS_ROOT}/db/migrate/fixtures/roles.csv", :headers => false)
	data.each do |row|
		Role.find_or_create_by_name(row[0])	
	end
	#===== end populate default roles =====

	#==== create the default admin user =====
	a = Role.find_by_name('Administrator')
		
	if (User.all.size == 0) || (User.find(:all, :conditions => ["roles_users.role_id = #{a.id}"]).size == 0)
		u = User.create(:login => 'admin',
								:email => 'dls@politicalboost.org',
								:password => 'admin123',
								:password_confirmation => 'admin123',
								:first_name => 'Desmond',
								:last_name => 'Stinnie',
								:phone => '4432793730',
								:active => 1)
		u.roles << a
	end
	a = nil
	#===== end create the default admin user =====

	#==== populate states table data ====
	data = FasterCSV.read("#{RAILS_ROOT}/db/migrate/fixtures/ZIPCODEWORLD-US-STATES.CSV", :headers => true)
	data.each do |row|
		s = nil
		s = State.find_by_abbrev(row[0])	
		if s.nil?
			s = State.create(:abbrev => row[0].to_s.upcase, :name => row[1].to_s.capitalize, :active=> row[2])
		else
			s.active = row[2]
		end
		s.save! if s.changed?
	end
	#==== end populate states table data ====

	#===== populate congressional_districts table data =====
		data = FasterCSV.read("#{RAILS_ROOT}/db/migrate/fixtures/congressional_districts.csv", :headers => true)
	data.each do |row|
		s = State.find_by_abbrev(row[0])
		CongressionalDistrict.find_or_create_by_cd_and_state_id(row[1], s.id)	
	end
	#===== end populate congressional_districts table data =====

	#===== populate senate_districts table data =====
		data = FasterCSV.read("#{RAILS_ROOT}/db/migrate/fixtures/senate_districts.csv", :headers => true)
	data.each do |row|
		s = State.find_by_abbrev(row[0])
		SenateDistrict.find_or_create_by_sd_and_state_id(row[1], s.id)	
	end
	#===== end populate senate_districts table data =====

	#===== populate house_districts table data =====
		data = FasterCSV.read("#{RAILS_ROOT}/db/migrate/fixtures/house_districts.csv", :headers => true)
	data.each do |row|
		s = State.find_by_abbrev(row[0])
		HouseDistrict.find_or_create_by_hd_and_state_id(row[1], s.id)	
	end
	#===== end populate house_districts table data =====

	#===== populate council_districts table data =====
		data = FasterCSV.read("#{RAILS_ROOT}/db/migrate/fixtures/comm_dist_codes.csv", :headers => true)
	data.each do |row|
		CouncilDistrict.find_or_create_by_code(row[2]) unless row[2].to_s == ''
	end
	#===== end populate council_districts table data =====
	
	#===== populate counties table data =====
		data = FasterCSV.read("#{RAILS_ROOT}/db/migrate/fixtures/comm_dist_codes.csv", :headers => true)
	data.each do |row|
		s = State.find_by_abbrev(row[0])
		c = County.find_or_create_by_name_and_state_id(row[1], s.id)	
		cd = CouncilDistrict.find_by_code(row[2])
		c.council_districts << cd unless cd.nil? || c.council_districts.exists?(cd)
	end
	#===== end populate counties table data =====
	
	#===== populate cities table data =====
		data = FasterCSV.read("#{RAILS_ROOT}/db/migrate/fixtures/comm_dist_codes_by_city.csv", :headers => true)
	data.each do |row|
		s = State.find_by_abbrev(row[0])
		county = County.find_by_name_and_state_id(row[1],s.id)
		city = City.find_or_create_by_name_and_state_id(row[2], s.id)
		city.counties << county unless county.nil? || city.counties.exists?(county)
	end
	#===== end populate cities table data =====

	#===== populate municipal_districts table data =====
		data = FasterCSV.read("#{RAILS_ROOT}/db/migrate/fixtures/municipal_districts.csv", :headers => true)
	data.each do |row|
		md = nil
		md = MunicipalDistrict.find_or_create_by_code(row[3]) unless row[3].to_s == ''
		if !md.nil?
			s = State.find_by_abbrev(row[0])
			city = City.find_by_name_and_state_id(row[2], s.id)
			md.cities << city unless city.nil? || md.cities.exists?(city)
		end
	end
	#===== end populate council_districts table data =====

	#===== populate precincts table data =====
		data = FasterCSV.read("#{RAILS_ROOT}/db/migrate/fixtures/precincts.csv", :headers => true)
	data.each do |row|
		next if row[2] != 'MD'

		p = nil
		p = Precinct.find_or_create_by_name_and_code(row[0], row[1]) unless row[1].to_s == ''
		if !p.nil?
			s = State.find_by_abbrev(row[2])
			if s.nil?
				debugger
			end

			#relate to state
			p.state = s if p.state.nil?
			
			#relate to county
			county = County.find_by_name_and_state_id(row[3],s.id)
			if county.nil?
				debugger
			end
			p.county = county if p.county.nil?
			raise "County does not match precinct" if p.county_id != county.id
			#relate to congressional district
			cd = CongressionalDistrict.find_by_cd_and_state_id(row[4], s.id)
			p.congressional_district = cd if p.congressional_district.nil?
			raise "CD does not match precinct" if p.congressional_district_id != cd.id
			
			#relate to senate district
			sd = SenateDistrict.find_by_sd_and_state_id(row[5], s.id)
			p.senate_district = sd if p.senate_district.nil?
			raise "SD does not match precinct" if p.senate_district_id != sd.id

			#relate to house district
			hd = HouseDistrict.find_by_hd_and_state_id(row[6], s.id)
			p.house_district = hd if p.house_district.nil?
			raise "HD does not match precinct" if p.house_district_id != hd.id
			
			#relate to council district
			comm_dist = CouncilDistrict.find_by_code(row[7])
			p.council_district = comm_dist if p.council_district.nil? && comm_dist
			raise "CommDistCode does not match precinct" if comm_dist &&  p.council_district_id != comm_dist.id 
			
			p.save! if p.changed?
			
		end
	end
	#===== end populate council_districts table data =====

	#===== populate parties table data =====
		data = FasterCSV.read("#{RAILS_ROOT}/db/migrate/fixtures/parties.csv", :headers => true)
	data.each do |row|
		Party.find_or_create_by_name_and_code(row[0], row[1])
	end
	#===== end populate parties table data =====

	#====== populate elections table data ======
	
	sql = "TRUNCATE TABLE elections"
	ActiveRecord::Base.connection.execute(sql)	

	data = FasterCSV.read("#{RAILS_ROOT}/db/migrate/fixtures/elections.csv", :headers => true)
	data.each do |row|
		Election.create!(:description => row[0], :year => row[1], :election_type => row[2])
	end

	#===== end populate elections table data ======
