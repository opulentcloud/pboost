class GisRegionJob < Struct.new(:gis_region_id)
	def perform
		GisRegion.populate_all_addresses_within(gis_region_id)
	end
end
