class SenateDistrict < ActiveRecord::Base

	#===== SCOPES ======
	default_scope :order => 'senate_districts.sd'

	#====== ASSOCIATIONS ======
	belongs_to :state
	has_many :counties, :through => :state
	has_many :precincts
	has_many :council_districts, :through => :precincts, :uniq => true
	
	#===== CLASS METHODS ======
	def self.to_json(sds)
		s = "{\"\" : \"Please choose\",\n"
		sds.each do |sd|
			s += "\"#{sd.id}\" : \"#{sd.sd}\",\n"
		end
		s = s[0,s.length-2]
		s += "}"
	end

end
