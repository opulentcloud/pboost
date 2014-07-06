class VanData < ActiveRecord::Base

  def table_name
    'van_data'
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
