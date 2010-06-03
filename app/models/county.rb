class County < ActiveRecord::Base

	#===== SCOPES ======
	default_scope :order => 'counties.name'

	#====== ASSOCIATIONS ======
	belongs_to :state
	has_many :cities

	#===== CLASS METHODS ======
	def self.to_json(counties)
		s = "{\"\" : \"Please choose\",\n"
		counties.each do |c|
			s += "\"#{c.id}\" : \"#{c.name}\",\n"
		end
		s = s[0,s.length-2]
		s += "}"
	end

end
