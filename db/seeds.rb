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
	if (User.all.size == 0) || (User.all(:conditions => { :roles => 'Administrator' }).size == 0)
		a = Role.find_by_name('Administrator')
		u = User.create(:login => 'admin',
								:email => 'dls@politicalboost.org',
								:password => 'admin123',
								:password_confirmation => 'admin123',
								:first_name => 'Desmond',
								:last_name => 'Stinnie',
								:phone => '4432793730',
								:active => 1)
		u.add_roles(a)								
	end
	#===== end create the default admin user =====

