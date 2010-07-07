class Precinct < ActiveRecord::Base

	#===== SCOPES ======
	default_scope :order => 'precincts.code'

	#====== ASSOCIATIONS ======
	belongs_to :state
	belongs_to :county
	belongs_to :congressional_district
	belongs_to :senate_district
	belongs_to :house_district
	belongs_to :council_district
	belongs_to :municipal_district
	has_many :city_precincts
	has_many :cities, :through => :city_precincts
	has_many :addresses, :foreign_key => :precinct_code, :primary_key => :code

	#===== CLASS METHODS ======
	def self.to_json(precincts)
		s = "{\"\" : \"Please choose\",\n"
		precincts.each do |c|
			s += "\"#{c.id}\" : \"#{c.code}\",\n"
		end
		s = s[0,s.length-2]
		s += "}"
	end

end
