class GisRegion < ActiveRecord::Base
	acts_as_geom :geom => :polygon

	#===== SCOPES ======
	default_scope :order => 'gis_regions.name'
		
	#===== VALIDATIONS ======
	validates_presence_of :name, :geom, :political_campaign_id

	#===== ASSOCIATIONS =====
	belongs_to :political_campaign
	has_and_belongs_to_many :addresses

	#===== INSTANCE METHODS ======
	def to_vertices_array
		r = []
		a = self.geom.text_representation.gsub(')','').gsub('(','').split(',')
		a.each do |s|
			r.push(s.split(' '))
		end
		r
	end

	def populate_all_addresses_within
		#find all the addresses within the bbox of this polygon
		addresses = Address.find_all_by_geom(self.geom)
		#now we must ask each address by point if it is inside the polygon
		addresses.each do |address|
			self.addresses << address if self.contains?(address.geom)
		end
		puts self.addresses.count
	end


	#===== CLASS METHODS ======
	def self.coordinates_from_text(text_coords)
		r = []
		ary = text_coords.to_s.split(',')

		for x in 0.step(ary.size-1,2)
			a1 = ary[x].to_s.gsub(/\[|\]/, '').to_f
			a2 = ary[x+1].to_s.gsub(/\[|\]/, '').to_f
			r.push([a1, a2])
		end
		r
	end

end
