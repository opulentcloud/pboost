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
      INNER JOIN voters v ON v.state_file_id = rvd.vtrid
      INNER JOIN addresses a ON a.id = v.address_id AND a.id = (SELECT MIN(id) FROM addresses WHERE addresses.address_hash = a.address_hash)
      INNER JOIN addresses an ON an.address_hash = rvd.address_hash
      WHERE 
      rvd.address_hash != a.address_hash) AS result
      WHERE voters.id = result.id}
    ActiveRecord::Base.connection.execute(query, :skip_logging)
  end

  def self.insert_new_voters
    query = %{INSERT INTO voters (last_name, first_name, middle_name, suffix, party, sex, dob, dor, state_file_id)
      SELECT r.lastname, r.firstname, r.middlename, r.suffix, r.party, r.gender, r.dob::date, r.state_registration_date::date, r.vtrid FROM registered_voters_data r
      LEFT OUTER JOIN voters ON voters.state_file_id = r.vtrid
      WHERE voters.id IS NULL}
    ActiveRecord::Base.connection.execute(query, :skip_logging)    
  end

  def self.update_voter_info_by_batch(voter_ids)
    Voter.joins(:registered_voters_data).where(id: voter_ids).each do |voter|
      voter.last_name = voter.registered_voters_data.lastname
      voter.first_name = voter.registered_voters_data.firstname
      voter.middle_name = voter.registered_voters_data.middlename
      voter.suffix = voter.registered_voters_data.suffix
      voter.party = voter.registered_voters_data.party
      voter.sex = voter.registered_voters_data.gender
      voter.dob = Chronic.parse(voter.registered_voters_data.dob).to_date
      voter.dor = Chronic.parse(voter.registered_voters_data.state_registration_date).to_date
      voter.search_index = Voter.build_search_index(voter.first_name, voter.last_name, voter.registered_voters_data.house_number)
      voter.updated_at = Time.now
      voter.created_at = Time.now unless voter.created_at.present?
      voter.save!
    end
  end
  
  def self.update_voter_info(last_datetime = Time.now)
    Voter.select(:id).find_in_batches(:batch_size => 1000) do |batch|
      RegisteredVotersData.delay.update_voter_info_by_batch(batch.map(&:id))
    end
  end
  
  def self.build_address_hashes(break_after = false)
    while RegisteredVotersData.where(address_hash: nil).exists? do
      RegisteredVotersData.transaction do
        RegisteredVotersData.where(address_hash: nil).limit(1000).each do |address|
          address.update_attribute(:address_hash, address.hash_full_address)
        end
      end
      break if break_after == true
    end
  end
  # end public class methods
end
