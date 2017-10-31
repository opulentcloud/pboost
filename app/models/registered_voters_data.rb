# == Schema Information
#
# Table name: registered_voters_data
#
#  vtrid                    :string(255)      not null, primary key
#  lastname                 :string(255)
#  firstname                :string(255)
#  middlename               :string(255)
#  suffix                   :string(255)
#  dob                      :string(255)
#  gender                   :string(255)
#  party                    :string(255)
#  house_number             :string(255)
#  house_suffix             :string(255)
#  street_predirection      :string(255)
#  streetname               :string(255)
#  streettype               :string(255)
#  street_postdirection     :string(255)
#  unittype                 :string(255)
#  unitnumber               :string(255)
#  address                  :string(255)
#  non_std_address          :string(255)
#  residentialcity          :string(255)
#  residentialstate         :string(255)
#  residentialzip5          :string(255)
#  residentialzip4          :string(255)
#  mailingaddress           :string(255)
#  mailingcity              :string(255)
#  mailingstate             :string(255)
#  mailingzip5              :string(255)
#  mailingzip4              :string(255)
#  country                  :string(255)
#  status_code              :string(255)
#  state_registration_date  :string(255)
#  county_registration_date :string(255)
#  precinct                 :string(255)
#  split                    :string(255)
#  county                   :string(255)
#  congressional_districts  :string(255)
#  legislative_districts    :string(255)
#  councilmanic_districts   :string(255)
#  ward_districts           :string(255)
#  municipal_districts      :string(255)
#  commissioner_districts   :string(255)
#  school_districts         :string(255)
#  address_hash             :string(32)
#

# Raw imported data from Maryland State Board of Elections system file
class RegisteredVotersData < ActiveRecord::Base

  def table_name
    'registered_voters_data'
  end

  self.primary_key = 'vtrid'

  # begin public instance methods
	def full_address
	 	if residentialzip4.blank?
			"#{full_street_address}, #{residentialcity}, #{residentialstate}, #{residentialzip5}"
		else
	    "#{full_street_address}, #{residentialcity}, #{residentialstate}, #{residentialzip5}-#{residentialzip4}"
	  end
  end

  def full_street_address
    "#{house_number} #{house_suffix} #{street_predirection} #{streetname} #{streettype} #{street_postdirection} #{unittype} #{unitnumber}".squeeze(" ").strip
  end

	def hash_full_address
		Digest::MD5.hexdigest(full_address.downcase)
	end

  # end public instance methods

  # begin public class methods
  def self.prepare_history_update(truncate=true)
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE registered_voters_history_updates") if truncate == true

    # this is the original query we were using when we were receiving
    # a separate voter history file.
    query = %{
       INSERT INTO registered_voters_history_updates (state_file_id, voter_type, election_year, election_month, election_type, created_at, updated_at)
        SELECT registered_voter_histories.vtrid AS state_file_id,
        CASE voting_method WHEN 'ABSENTEE' THEN 'A' WHEN 'EARLY VOTING' THEN 'E' WHEN 'FWAB' THEN 'F' WHEN 'POLLING PLACE' THEN 'P' WHEN 'PROVISIONAL' THEN 'V' END AS voter_type,
        split_part(election_date, '/', 3)::int AS election_year,
        split_part(election_date, '/', 1)::int AS election_month,
        CASE election_type WHEN 'Gubernatorial General' THEN 'GG' WHEN 'Gubernatorial Primary' THEN 'GP' WHEN 'Presidential General' THEN 'G' WHEN 'Presidential Primary' THEN 'P' END AS election_type,
        current_date as created_at, current_date as updated_at
        FROM registered_voter_histories
        ORDER BY vtrid
    }
    # ActiveRecord::Base.connection.execute(query, :skip_logging)

    query1 = %{
      INSERT INTO registered_voters_history_updates (state_file_id, voter_type, election_year, election_month, election_type, created_at, updated_at)
      SELECT registered_voters_data.vtrid AS state_file_id,
      'P' AS voter_type,
      CASE split_part(vote1, ' ', 1) WHEN '2006' THEN 2006 WHEN '2012' THEN 2012 ELSE 2006 END AS election_year,
      CASE vote1 WHEN '2012 PRESIDENTIAL GENERAL ELECTION' THEN 11 when 'Primary Election - 2006' THEN NULL ELSE 6 END AS election_month,
      CASE vote1 WHEN '2012 PRESIDENTIAL GENERAL ELECTION' THEN 'G' WHEN 'Primary Election - 2006' THEN 'P' ELSE 'GP' END AS election_type,
      current_date as created_at, current_date as updated_at
      FROM registered_voters_data
      ORDER BY vtrid
    }
    ActiveRecord::Base.connection.execute(query1, :skip_logging)

    query2 = %{
      SELECT registered_voters_data.vtrid AS state_file_id,
      'P' AS voter_type,
      CASE split_part(vote2, ' ', 1) WHEN '2014' THEN 2014 ELSE 2006 END AS election_year,
      CASE vote2 WHEN '2014 GUBERNATORIAL PRIMARY ELECTION' THEN 6 ELSE NULL END AS election_month,
      CASE vote2 WHEN '2014 GUBERNATORIAL PRIMARY ELECTION' THEN 'GP' WHEN '2006 GUBERNATORIAL GENERAL ELECTION' THEN 'GG' WHEN 'GUBERNATORIAL GENERAL - 2006' THEN 'GG' WHEN 'GUBERNATORIAL GENERAL ELECTION - 2006' THEN 'GG' WHEN 'GUB. GENERAL ELECTION' THEN 'GG' ELSE 'G' END AS election_type,
      current_date as created_at, current_date as updated_at
      FROM registered_voters_data
      ORDER BY vtrid
    }
    ActiveRecord::Base.connection.execute(query2, :skip_logging)

    query3 = %{
      INSERT INTO registered_voters_history_updates (state_file_id, voter_type, election_year, election_month, election_type, created_at, updated_at)
      SELECT registered_voters_data.vtrid AS state_file_id,
      'P' AS voter_type,
      CASE split_part(vote3, ' ', 1) WHEN '2014' THEN 2014 WHEN '2012' THEN 2012 END AS election_year,
      CASE vote3 WHEN '2012 PRESIDENTIAL PRIMARY ELECTION' THEN 4 WHEN '2014 GUBERNATORIAL GENERAL ELECTION' THEN 11 END AS election_month,
      CASE vote3 WHEN '2012 PRESIDENTIAL PRIMARY ELECTION' THEN 'P' WHEN '2014 GUBERNATORIAL GENERAL ELECTION' THEN 'GG' END AS election_type,
      current_date as created_at, current_date as updated_at
      FROM registered_voters_data
      WHERE (CASE split_part(vote3, ' ', 1) WHEN '2014' THEN 2014 WHEN '2012' THEN 2012 END) IS NOT NULL
      ORDER BY vtrid
    }
    ActiveRecord::Base.connection.execute(query3, :skip_logging)

    query4 = %{
      INSERT INTO registered_voters_history_updates (state_file_id, voter_type, election_year, election_month, election_type, created_at, updated_at)
      SELECT registered_voters_data.vtrid AS state_file_id,
      'P' AS voter_type,
      CASE split_part(vote4, ' ', 1) WHEN '2010' THEN 2010 WHEN '2016' THEN 2016 END AS election_year,
      CASE vote4 WHEN '2010 GUBERNATORIAL PRIMARY ELECTION' THEN 6 WHEN '2016 PRESIDENTIAL GENERAL ELECTION' THEN 11 END AS election_month,
      CASE vote4 WHEN '2010 GUBERNATORIAL PRIMARY ELECTION' THEN 'GP' WHEN '2016 PRESIDENTIAL GENERAL ELECTION' THEN 'P' END AS election_type,
      current_date as created_at, current_date as updated_at
      FROM registered_voters_data
      WHERE (CASE split_part(vote4, ' ', 1) WHEN '2010' THEN 2010 WHEN '2016' THEN 2016 END) IS NOT NULL
      ORDER BY vtrid
    }
    ActiveRecord::Base.connection.execute(query4, :skip_logging)

    query5 = %{
      INSERT INTO registered_voters_history_updates (state_file_id, voter_type, election_year, election_month, election_type, created_at, updated_at)
      SELECT registered_voters_data.vtrid AS state_file_id,
      'P' AS voter_type,
      CASE split_part(vote5, ' ', 1) WHEN '2010' THEN 2010 WHEN '2016' THEN 2016 END AS election_year,
      CASE vote5 WHEN '2010 GUBERNATORIAL GENERAL ELECTION' THEN 11 WHEN '2016 PRESIDENTIAL PRIMARY ELECTION' THEN 4 END AS election_month,
      CASE vote5 WHEN '2010 GUBERNATORIAL GENERAL ELECTION' THEN 'GG' WHEN '2016 PRESIDENTIAL PRIMARY ELECTION' THEN 'P' END AS election_type,
      current_date as created_at, current_date as updated_at
      FROM registered_voters_data
      WHERE (CASE split_part(vote5, ' ', 1) WHEN '2010' THEN 2010 WHEN '2016' THEN 2016 END) IS NOT NULL
      ORDER BY vtrid
    }
    ActiveRecord::Base.connection.execute(query5, :skip_logging)


  end

  def self.history_update
    query = %{
      INSERT INTO voting_histories (state_file_id, voter_type, election_year, election_month, election_type, created_at, updated_at)
        SELECT u.state_file_id, u.voter_type, u.election_year, u.election_month, u.election_type, u.created_at, u.updated_at FROM registered_voters_history_updates u
        INNER JOIN voters v ON v.state_file_id = u.state_file_id
        LEFT OUTER JOIN voting_histories h ON h.state_file_id = u.state_file_id  AND h.election_type = u.election_type AND h.election_year = u.election_year AND h.election_month = u.election_month
        WHERE h.id IS NULL
        LIMIT 1000;
    }
    ActiveRecord::Base.connection.execute(query, :skip_logging)
  end

  def self.update_addresses
    query = %{UPDATE addresses
	    SET street_no = result.house_number,
	    street_no_int = result.street_no_int,
	    is_odd = result.is_odd,
	    street_no_half = result.house_suffix,
	    street_prefix = result.street_predirection,
	    street_name = result.streetname,
	    street_type = result.streettype,
	    street_suffix = result.street_postdirection,
	    apt_type = result.unittype,
	    apt_no = result.unitnumber,
	    city = result.residentialcity,
	    state = result.residentialstate,
	    zip5 = result.residentialzip5,
	    zip4 = result.residentialzip4,
	    county_name = result.county,
	    precinct_name = result.precinct_name,
	    precinct_code = result.precinct_code,
	    cd = result.congressional_districts,
	    hd = result.legislative_districts,
	    sd = result.sd,
	    comm_dist_code = result.councilmanic_districts,
	    ward_district = result.ward_districts,
	    municipal_district = result.municipal_districts,
	    school_district = result.school_districts
    FROM
	    (SELECT r.house_number,COALESCE(r.house_number, '0')::int as street_no_int,mod(COALESCE(r.house_number, '0')::int,2) = 1 as is_odd,r.house_suffix,r.street_predirection,r.streetname,r.streettype,r.street_postdirection,r.unittype,r.unitnumber,r.residentialcity,r.residentialstate,r.residentialzip5,r.residentialzip4,r.county,r.precinct as precinct_name,r.precinct as precinct_code,LPAD(r.congressional_districts,3,'0') as congressional_districts,LPAD(r.legislative_districts,3,'0') as legislative_districts,LPAD(r.legislative_districts,3,'0') as sd,r.councilmanic_districts,r.ward_districts,r.municipal_districts,r.school_districts,r.address_hash
		    FROM registered_voters_data r) AS result
	    WHERE addresses.address_hash = result.address_hash}
    ActiveRecord::Base.connection.execute(query, :skip_logging)
  end

  def self.insert_new_addresses
    query = %{INSERT INTO addresses (street_no,street_no_half,street_prefix,street_name,street_type,street_suffix,apt_type,
	  apt_no,city,state,zip5,zip4,county_name,precinct_name,precinct_code,cd,sd,hd,comm_dist_code,ward_district,municipal_district,school_district,address_hash)
      SELECT DISTINCT ON (r.address_hash) r.house_number,r.house_suffix,r.street_predirection,r.streetname,r.streettype,r.street_postdirection,r.unittype,
	      r.unitnumber,r.residentialcity,r.residentialstate,r.residentialzip5,r.residentialzip4,r.county,r.precinct as precint_name,r.precinct as precinct_code,LPAD(r.congressional_districts,3,'0') as congressional_districts,LPAD(r.legislative_districts,3,'0') as sd,LPAD(r.legislative_districts,3,'0') as legislative_districts,r.councilmanic_districts,r.ward_districts,r.municipal_districts,r.school_districts,r.address_hash
      FROM registered_voters_data r
      LEFT OUTER JOIN addresses a ON a.address_hash = r.address_hash
      WHERE r.address_hash IS NOT NULL AND a.address_hash IS NULL}
    ActiveRecord::Base.connection.execute(query, :skip_logging)
  end

  def self.update_voters_addresses
    query =%{UPDATE voters
	      SET address_id = result.new_address_id
      FROM
      (SELECT DISTINCT ON (v.id) v.id, a.address_hash as old_address_hash, an.address_hash as new_address_hash, an.id as new_address_id from registered_voters_data rvd
      INNER JOIN voters v ON v.state_file_id = rvd.vtrid::int
      INNER JOIN addresses a ON a.id = v.address_id AND a.id = (SELECT MIN(id) FROM addresses WHERE addresses.address_hash = a.address_hash)
      INNER JOIN addresses an ON an.address_hash = rvd.address_hash
      WHERE
      rvd.address_hash != a.address_hash) AS result
      WHERE voters.id = result.id}
    ActiveRecord::Base.connection.execute(query, :skip_logging)
  end

  def self.insert_new_voters
    query_2016 = %{INSERT INTO voters (last_name, first_name, middle_name, suffix, party, sex, dob, dor, state_file_id)
      SELECT r.lastname, r.firstname, r.middlename, r.suffix, r.party, r.gender, r.dob::date, r.state_registration_date::date, r.vtrid::int FROM registered_voters_data r
      LEFT OUTER JOIN voters ON voters.state_file_id = r.vtrid::int
      WHERE voters.id IS NULL}

    query = %{INSERT INTO voters (last_name, first_name, middle_name, suffix, party, sex, dob, dor, state_file_id)
      SELECT r.lastname, r.firstname, r.middlename, r.suffix, r.party, SUBSTRING(r.gender,1,1) as sex, NULL::date as dob, r.state_registration_date::date, r.vtrid::int FROM registered_voters_data r
      LEFT OUTER JOIN voters ON voters.state_file_id = r.vtrid::int
      WHERE voters.id IS NULL}
    ActiveRecord::Base.connection.execute(query, :skip_logging)
  end

  # Remove any voters no longer in the new raw data file.
  def self.remove_old_voters
    query = %{
      DELETE FROM voters WHERE ID IN (
        SELECT v.id FROM voters v
        LEFT OUTER JOIN registered_voters_data d ON d.vtrid::int = v.state_file_id
        WHERE d.vtrid IS NULL)
    }
    ActiveRecord::Base.connection.execute(query, :skip_logging)
  end

  def self.update_voter_info_by_batch(voter_ids)
    Voter.joins("INNER JOIN registered_voters_data d ON d.vtrid::int = voters.state_file_id").where(id: voter_ids).each do |voter|
      voter.last_name = voter.registered_voters_data.lastname
      voter.first_name = voter.registered_voters_data.firstname
      voter.middle_name = voter.registered_voters_data.middlename
      voter.suffix = voter.registered_voters_data.suffix
      voter.party = voter.registered_voters_data.party
      voter.sex = voter.registered_voters_data.gender
      #bod data no longer provides us with their dob...
      #voter.dob = Chronic.parse(voter.registered_voters_data.dob).to_date rescue nil
      voter.dor = Chronic.parse(voter.registered_voters_data.state_registration_date).to_date rescue nil
      voter.yor = voter.dor.year rescue nil
      voter.search_index = Voter.build_search_index(voter.first_name, voter.last_name, voter.registered_voters_data.house_number)
      voter.search_index2 = voter.build_search2 #Voter.build_search_index2(voter.first_name, voter.last_name, voter.registered_voters_data.dob)
      voter.updated_at = Time.now
      voter.created_at = Time.now unless voter.created_at.present?
      voter.save!
    end
  end

  def self.update_voter_info(last_datetime = Time.now)
    #Voter.select(:id).where(search_index: nil).find_in_batches(:batch_size => 1000) do |batch|
    Voter.select(:id).find_in_batches(:batch_size => 1000) do |batch|
      RegisteredVotersData.delay.update_voter_info_by_batch(batch.map(&:id))
    end
  end

  def self.build_address_hashes(break_after = false)
    cnt = 0
    while RegisteredVotersData.where(address_hash: nil).exists? do
      RegisteredVotersData.transaction do
        RegisteredVotersData.where(address_hash: nil).limit(1000).each do |address|
          address.update_attribute(:address_hash, address.hash_full_address)
        end
        cnt += 1000
        puts cnt
      end
      break if break_after == true
    end
  end
  # end public class methods
end
