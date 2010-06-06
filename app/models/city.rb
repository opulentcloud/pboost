class City < ActiveRecord::Base

	#===== SCOPES ======
	default_scope :order => 'cities.name'

	#====== ASSOCIATIONS ======
	has_and_belongs_to_many :counties
	belongs_to :state
	has_and_belongs_to_many :municipal_districts

	#===== CLASS METHODS ======
	def self.to_json(cities)
		st = "{\"\" : \"Please choose\",\n"
		cities.each do |c|
			st += "\"#{c.id}\" : \"#{c.name}\",\n"
		end
		st = st[0,st.length-2]
		st += "}"
	end

end
