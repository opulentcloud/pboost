class State < ActiveRecord::Base
	default_scope :order => "states.abbrev ASC"

	named_scope :active, {
		:select => "states.*",
		:conditions => "states.active = true ",
		:order => "states.abbrev ASC"
	}

end
