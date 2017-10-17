require 'csv'

if ENV['hoa'].present?
  Email.connection.execute("UPDATE voters SET email = LOWER(email) WHERE email is not null;")
  data = CSV.read("#{Rails.root}/db/fixtures/emails_vf.csv", :headers => false)
  data.each do |row|
    next if row[0].to_s.blank?
    email = Email.where("address = ?", row[0].to_s.downcase).first
    unless email
      Email.create(address: row[0].to_s.downcase)
    end
  end
end

if false
  xml = IO.read("#{Rails.root}/622.xml")
end

if ENV['initseed'].present?

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

  # ==== begin load addresses from van_data table =====
  query = %{
  INSERT INTO addresses (street_no, street_no_half,street_prefix,street_name,street_type,street_suffix,apt_type,
  	  apt_no,city,state,zip5,zip4,county_name,precinct_name,precinct_code,cd,sd,hd,comm_dist_code)
    SELECT street_no, street_no_half,street_prefix,street_name,street_type,street_suffix,apt_type,
  	  apt_no,city,state,zip5,zip4,county_name,precinct_name,precinct_code,cd,sd,hd,comm_dist_code
    FROM van_data}

  results = ActiveRecord::Base.connection.execute(query, :skip_logging) if false
  # ==== end load addresses from van_data table =====

  # ==== begin load voters from van_data table =====
  query = %{
  INSERT INTO voters (vote_builder_id, last_name, first_name, middle_name, suffix, salutation, phone, home_phone, work_phone, work_phone_ext,
  	cell_phone, email, party, sex, age, dob, dor, state_file_id)
  SELECT vote_builder_id::bigint, last_name, first_name, middle_name, suffix, salutation, phone, home_phone, work_phone, work_phone_ext,
  	cell_phone, email, party, sex, age::int, dob::date, dor::date, state_file_id
  FROM van_data}
  results = ActiveRecord::Base.connection.execute(query, :skip_logging) if false
  # ==== end load voters from van_data table =====
end
