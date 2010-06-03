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
	has_many :cities, :through => :counties
	has_many :council_districts, :through => :cities
	has_many :congressional_districts
	has_many :senate_districts
	has_many :house_districts

end
