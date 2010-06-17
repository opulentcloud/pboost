class CongressionalDistrict < ActiveRecord::Base

	#===== SCOPES ======
	default_scope :order => 'congressional_districts.cd'

	#====== ASSOCIATIONS ======
	belongs_to :state
	has_many :precincts

	#===== CLASS METHODS ======
	def self.to_json(cds)
		s = "{\"\" : \"Please choose\",\n"
		cds.each do |cd|
			s += "\"#{cd.id}\" : \"#{cd.cd}\",\n"
		end
		s = s[0,s.length-2]
		s += "}"
	end

end
