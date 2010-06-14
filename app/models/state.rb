class State < ActiveRecord::Base
	#===== SCOPES ======
	default_scope :order => "states.abbrev ASC"

	named_scope :active, {
		:select => "states.*",
		:conditions => "states.active = true ",
		:order => "states.abbrev ASC"
	}

	#====== ASSOCIATIONS ======
	has_many :counties
	has_many :cities
	has_many :congressional_districts
	has_many :senate_districts
	has_many :house_districts

	#===== VALIDATIONS ======
	validate :valid_county

	#===== INSTANCE METHODS ======
  def valid_county
  	return true unless (self.lat.blank? && self.lng.blank?)
    @state_string ||= "#{self.name}, USA"
    
    res= Geokit::Geocoders::GoogleGeocoder.geocode(@state_string, :bias => 'us')
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
	def self.do_geocoding
		states = State.all(:conditions => { :lat => nil })
		states.each do |state|
			begin
				state.save!
			rescue
			end
			sleep 0.10
		end
	end

end
