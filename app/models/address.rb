class Address < ActiveRecord::Base
  acts_as_reportable
  acts_as_mappable
  acts_as_geom :geom => :point

	#===== ASSOCIATIONS ======
	has_and_belongs_to_many :gis_regions
	has_many :voters

	#===== VALIDATIONS ======
  #only enable this go get lat, lng, and geom point saved
  #into the database
  validate :valid_address

	#====== EVENTS ======
	before_save :hash_full_address
  
	#===== INSTANCE METHODS ======
	def hash_full_address
		self.address_hash = Digest::MD5.hexdigest(self.full_address.downcase)
	end
   
  def valid_address
  	return true unless (self.lat.blank? && self.lng.blank? && self.geom.blank?)
    @address_string ||= [:full_street_address, :city, :state, :zip5].map{|f|
       self.send(f)}.join(',')
    
    #res= Geokit::Geocoders::GoogleGeocoder.geocode(@address_string, :bias => 'us')
    res = Geokit::Geocoders::MultiGeocoder.geocode(@address_string, :bias => 'us')
    puts res.success
    puts res.precision.to_sym
    if res.success 
    	if (res.precision.to_sym == :address || res.precision.to_sym == :building)
	      #self.street_address = res.street_address
	      #self.city = res.city
	      #self.region = res.state
	      #self.postal_code 	= res.zip.gsub(/\s+/,'') unless res.zip.nil?  

	      self.lat = res.lat
	      self.lng = res.lng
				self.geom = Point.from_x_y(lat,lng)
			else
				self.geo_failed = true
			end
    else
      errors.add_to_base('Geocode completely failed.')
    end

  end

	def full_street_address
		"#{street_no} #{street_no_half} #{street_prefix} #{street_name} #{street_type} #{street_suffix} #{apt_type} #{apt_no}".squeeze(" ").strip
	end

	def full_address
	 	if self.zip4.blank?
			"#{full_street_address}, #{city}, #{state}, #{zip5}"
		else
	    "#{full_street_address}, #{city}, #{state}, #{zip5}-#{zip4}"
	  end
  end

	#====== CLASS METHODS ======
	def self.do_geocoding(done_cnt=0)
		cnt = 0
		the_limit = 15000 - done_cnt
		
		ads = Address.all(:conditions => "(county_name = 'Baltimore') AND (comm_dist_code = '2' or comm_dist_code = '4') AND geom IS NULL AND geo_failed IS NULL", :limit => the_limit)
		
		ads.each do |a|
			a.save! if a.valid?
			sleep 0.10
			cnt += 1
			puts cnt
			break if cnt > 15000
		end
	end

	def self.create_address_hashes
		#Address.transaction do
			Address.all(:conditions => 'address_hash is null', :limit => 50000).each do |a|
				a.save!
			end
		#end
	end

end
