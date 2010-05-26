class TimeZone < ActiveRecord::Base
	#===== SCOPES =====
	default_scope :order => 'time_zones.zone'

	#===== VALIDATIONS =====
	validates_presence_of :zone
	validates_uniqueness_of :zone

	#===== ASSOCIATIONS =====
	has_many :users

end
