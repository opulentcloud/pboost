# == Schema Information
#
# Table name: addresses
#
#  id                    :integer          not null, primary key
#  street_no             :string(10)
#  street_no_half        :string(10)
#  street_prefix         :string(10)
#  street_name           :string(50)
#  street_type           :string(10)
#  street_suffix         :string(10)
#  apt_type              :string(10)
#  apt_no                :string(20)
#  city                  :string(32)
#  state                 :string(2)
#  zip5                  :string(5)
#  zip4                  :string(4)
#  county_name           :string(32)
#  precinct_name         :string(32)
#  precinct_code         :string(32)
#  cd                    :string(3)
#  sd                    :string(3)
#  hd                    :string(3)
#  comm_dist_code        :string(3)
#  lat                   :decimal(15, 10)
#  lng                   :decimal(15, 10)
#  geo_failed            :boolean
#  address_hash          :string(32)
#  is_odd                :boolean
#  street_no_int         :integer
#  created_at            :datetime
#  updated_at            :datetime
#  ward_district         :string(10)
#  municipal_district    :string(10)
#  commissioner_district :string(10)
#  school_district       :string(10)
#

class Address < ActiveRecord::Base

  #exclude some fields from ransack search  
  UNRANSACKABLE_ATTRIBUTES = ['id','precinct_name','lat','lng','geo_failed','address_hash',
  'apt_type', 'is_odd', 'zip4', 'street_no_int','geom','created_at','updated_at','street_address']

  def self.ransackable_attributes auth_object = nil
    (column_names - UNRANSACKABLE_ATTRIBUTES) + _ransackers.keys
  end

  def self.client_column_names
    ['street_address','city','state','zip5']
  end
  # begin associations
  has_many :voters
  # end associations
  
  # begin public instance methods
	def full_address
	 	if zip4.blank?
			"#{full_street_address}, #{city}, #{state}, #{zip5}"
		else
	    "#{full_street_address}, #{city}, #{state}, #{zip5}-#{zip4}"
	  end
  end

  def city_state_zip
    "#{city}, #{state}, #{zip5}-#{zip4}".squeeze(' ').strip
  end

  def full_street_address
    "#{street_no} #{street_no_half} #{street_prefix} #{street_name} #{street_type} #{street_suffix} #{apt_type} #{apt_no}".squeeze(" ").strip
  end

  def full_street_number
    "#{street_no} #{street_no_half}".squeeze(" ").strip    
  end

  def full_street_name
    "#{street_prefix} #{street_name} #{street_type} #{street_suffix}".squeeze(" ").strip
  end

  def full_apt_number
    "#{apt_type} #{apt_no}".squeeze(" ").strip  
  end

	def hash_full_address
		Digest::MD5.hexdigest(full_address.downcase)
	end
  
  # end public instance methods
  
  # begin public class methods
  def self.populate_street_addresses_by_batch(address_ids)
    Address.where(id: address_ids).each do |address|
      address.update_attribute(:street_address, address.full_street_address)
    end
  end

  def self.populate_street_addresses
    Address.where(street_address: nil).find_in_batches(:batch_size => 1000) do |batch|
      Address.delay(priority: 10).populate_street_addresses_by_batch(batch.map(&:id))
    end
  end

  def self.build_address_hashes
    Address.where(address_hash: nil).find_in_batches(:batch_size => 1000) do |batch|
      Address.transaction do
        batch.each do |address|
          address.update_attribute(:address_hash, address.hash_full_address)
        end
      end
    end
  end
  
  def self.delete_duplicate_addresses
    query = %{
      DELETE FROM addresses WHERE addresses.id IN \
        (SELECT MAX(addresses.id) FROM addresses WHERE address_hash IN \
        (SELECT address_hash FROM \
        (SELECT COUNT(addresses.id) as cnt, addresses.address_hash FROM addresses WHERE address_hash IS NOT NULL GROUP BY address_hash) AS result \
        WHERE cnt > 1) GROUP BY address_hash); }
    ActiveRecord::Base.connection.execute(query)
  end
	
  # end public class methods
end
