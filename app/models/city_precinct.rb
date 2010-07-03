class CityPrecinct < ActiveRecord::Base

	#===== ASSOCIATIONS ======
	belongs_to :city
	belongs_to :precinct
	
	#===== VALIDATIONS =====
	validates_uniqueness_of :precinct_id, :scope => :city_id

end
