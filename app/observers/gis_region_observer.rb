class GisRegionObserver < ActiveRecord::Observer
	@@delayed_job = true

	def after_create(gis_region)

		if @@delayed_job then
			GisRegion.send_later(:populate_all_addresses_within, gis_region)
		else
  		gis_region.populate_all_addresses_within
		end
	end	

end

