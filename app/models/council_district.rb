class CouncilDistrict < ActiveRecord::Base

	#===== SCOPES ======
	default_scope :order => 'council_districts.code'

	#====== ASSOCIATIONS ======
	has_and_belongs_to_many :cities
	has_many :counties, :through => :cities
	has_many :states, :through => :counties

end
