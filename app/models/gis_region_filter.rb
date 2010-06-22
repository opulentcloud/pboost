class GisRegionFilter < Filter

	#====== VALIDATIONS =======
	#validates_inclusion_of :int_val, :in => GisRegion.all.map(&:id), :message => 'GIS Region is not valid.', :if => Proc.new { |g| g.int_val != nil }

	validate :valid_gis_region, :message => 'GIS Region is not valid.'
	
	def valid_gis_region
		return true unless self.int_val != nil
		GisRegion.exists?(self.int_val)
	end

end
