class City < ActiveRecord::Base

	#===== SCOPES ======
	default_scope :order => 'cities.name'

	#====== ASSOCIATIONS ======
	has_and_belongs_to_many :counties
	belongs_to :state
	has_and_belongs_to_many :municipal_districts
	has_and_belongs_to_many :precincts

	#===== VALIDATIONS ======
	validate :valid_city

	#===== INSTANCE METHODS ======
  def valid_city
  	return true unless (self.lat.blank? && self.lng.blank?)
    @city_string ||= "#{self.name}, #{self.state.abbrev}"
    
    res= Geokit::Geocoders::GoogleGeocoder.geocode(@city_string, :bias => 'us')
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
	def self.to_json(cities)
		st = "{\"\" : \"Please choose\",\n"
		cities.each do |c|
			st += "\"#{c.id}\" : \"#{c.name}\",\n"
		end
		st = st[0,st.length-2]
		st += "}"
	end

	def self.do_geocoding
		cities = City.all(:conditions => { :lat => nil })
		cities.each do |city|
			city.save!
			sleep 0.10
		end
	end

end
