require 'csv'

if false
  xml = IO.read("#{Rails.root}/622.xml")
end

#====== populate default roles =====
data = CSV.read("#{Rails.root}/db/fixtures/roles.csv", :headers => false)
data.each do |row|
	Role.find_or_create_by(name: row[0])	
end
#===== end populate default roles =====

#===== create the default users =====
if true
  User.create!(email: 'mark@wilsonsdev.com', first_name: 'Mark', last_name: 'Wilson', password: 'password123', password_confirmation: 'password123') do |u|
    Role.all.each do |r|
      u.roles << r
    end
  end
end
#===== end create the default users =====

