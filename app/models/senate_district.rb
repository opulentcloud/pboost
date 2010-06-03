class SenateDistrict < ActiveRecord::Base

	#===== SCOPES ======
	default_scope :order => 'senate_districts.sd'

	#====== ASSOCIATIONS ======
	belongs_to :state

	#===== CLASS METHODS ======
	def self.to_json(sds)
		s = "{\"\" : \"Please choose\",\n"
		sds.each do |sd|
			s += "\"#{sd.sd}\" : \"#{sd.sd}\",\n"
		end
		s = s[0,s.length-2]
		s += "}"
	end

end
