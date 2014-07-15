# == Schema Information
#
# Table name: registered_voters_data
#
#  vtrid                    :string(255)
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
  
  self.primary_key = 'state_file_id'

  # begin public instance methods
	def full_address
	 	if zip4.blank?
			"#{full_street_address}, #{city}, #{state}, #{zip5}"
		else
	    "#{full_street_address}, #{city}, #{state}, #{zip5}-#{zip4}"
	  end
  end

  def full_street_address
    "#{street_no} #{street_no_half} #{street_prefix} #{street_name} #{street_type} #{street_suffix} #{apt_type} #{apt_no}".squeeze(" ").strip
  end

	def hash_full_address
		Digest::MD5.hexdigest(full_address.downcase)
	end
  
  # end public instance methods
  
  # begin public class methods
  def self.build_address_hashes(break_after = false)
    while VanData.where(address_hash: nil).exists? do
      VanData.transaction do
        VanData.where(address_hash: nil).limit(1000).each do |address|
          address.update_attribute(:address_hash, address.hash_full_address)
        end
      end
      break if break_after == true
    end
  end
  # end public class methods
end
