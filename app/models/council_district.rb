class CouncilDistrict < ActiveRecord::Base

	#===== SCOPES ======
	default_scope :order => 'council_districts.code'

	#====== ASSOCIATIONS ======
	has_and_belongs_to_many :cities
	has_and_belongs_to_many :counties
	has_many :states, :through => :counties
	has_many :precincts
	
	#===== CLASS METHODS ======
	def self.to_json(council_districts)
		s = "{\"\" : \"Please choose\",\n"
		council_districts.each do |c|
			s += "\"#{c.id}\" : \"#{c.code}\",\n"
		end
		s = s[0,s.length-2]
		s += "}"
	end

end
