class Address < ActiveRecord::Base

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

	def hash_full_address
		Digest::MD5.hexdigest(full_address.downcase)
	end
  
  # end public instance methods
  
  # begin public class methods
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
