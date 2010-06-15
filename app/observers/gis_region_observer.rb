class GisRegionObserver < ActiveRecord::Observer

	def after_create(gis_region)
		Delayed::Job.enqueue GisRegionJob.new(gis_region.id)
	end	

end

