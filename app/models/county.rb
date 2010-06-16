class County < ActiveRecord::Base

	#===== SCOPES ======
	default_scope :order => 'counties.name'

	#====== ASSOCIATIONS ======
	belongs_to :state
	has_and_belongs_to_many :cities
	has_and_belongs_to_many :council_districts

	#===== VALIDATIONS ======
	validate :valid_county

	#===== INSTANCE METHODS ======
	def lat
		self.county.lat
	end
	
	def lng
		self.county.lng
	end
	
  def valid_county
  	return true unless (self.lat.blank? && self.lng.blank?)
    @county_string ||= "#{self.name} County, #{self.state.abbrev}"
    
    res= Geokit::Geocoders::GoogleGeocoder.geocode(@county_string, :bias => 'us')
    puts res.success
    puts res.precision.to_sym
    if res.success 
	      self.lat = res.lat
	      self.lng = res.lng
    else
      errors.add_to_base('Geocode completely failed.')
    end

  end

	#===== CLASS METHODS ======
	def self.to_json(counties)
		s = "{\"\" : \"Please choose\",\n"
		counties.each do |c|
			s += "\"#{c.id}\" : \"#{c.name}\",\n"
		end
		s = s[0,s.length-2]
		s += "}"
	end

	def self.do_geocoding
		counties = County.all(:conditions => { :lat => nil })
		counties.each do |county|
			county.save!
			sleep 0.10
		end
	end

end
