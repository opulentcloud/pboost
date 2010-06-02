# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

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
	s = State.find_or_create_by_abbrev_and_name(row[0], row[1])	
	@disable = false
	case s.abbrev
	when 'AA' then 
		@disable = true
	when 'AE' then
		@disable = true
	when 'AP' then
		@disable = true
	when 'AS' then
		@disable = true
	when 'FM' then
		@disable = true
	when 'GU' then
		@disable = true
	when 'MH' then
		@disable = true
	when 'MP' then
		@disable = true
	when 'PR' then
		@disable = true
	when 'PW' then
		@disable = true
	when 'VI' then
		@disable = true
	end
	if @disable
		s.active = false
		s.save!
	end
	end
	#==== end populate states table data ====

