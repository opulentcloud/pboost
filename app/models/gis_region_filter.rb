class GisRegionFilter < Filter

	#====== VALIDATIONS =======
	validates_inclusion_of :int_val, :in => GisRegion.all.map(&:id), :message => 'GIS Region is not valid.', :if => Proc.new { |g| g.int_val != nil }

end
