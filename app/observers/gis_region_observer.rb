class GisRegionObserver < ActiveRecord::Observer

	@@delayed_job = RAILS_ENV == 'production'

	def after_create(gis_region)
		if @@delayed_job == true
			Delayed::Job.enqueue GisRegionJob.new(gis_region.id)
		else
			GisRegion.populate_all_addresses_within(gis_region.id)
		end
	end	

end

