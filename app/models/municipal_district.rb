class MunicipalDistrict < ActiveRecord::Base

	#===== SCOPES ======
	default_scope :order => 'municipal_districts.code'

	#====== ASSOCIATIONS ======
	has_and_belongs_to_many :cities
	has_many :counties, :through => :cities
	has_many :states, :through => :counties
	has_many :precincts

	#===== CLASS METHODS ======
	def self.to_json(municipal_districts)
		s = "{\"\" : \"Please choose\",\n"
		municipal_districts.each do |m|
			s += "\"#{m.id}\" : \"#{m.code}\",\n"
		end
		s = s[0,s.length-2]
		s += "}"
	end

end
