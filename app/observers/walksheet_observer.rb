class WalksheetObserver < ActiveRecord::Observer

	@@delayed_job = RAILS_ENV == 'production'

	def after_create(walksheet)
		if @@delayed_job == true
			Delayed::Job.enqueue WalksheetJob.new(walksheet.id)
		else
			walksheet.populate
		end
	end	

	def after_update(walksheet)
		return true unless walksheet.repopulate == true
		#if @@delayed_job == true
			Delayed::Job.enqueue WalksheetJob.new(walksheet.id)
		#else
		#	walksheet.populate
		#end
	end	

end

