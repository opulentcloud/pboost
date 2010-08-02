class RobocallListObserver < ActiveRecord::Observer

	@@delayed_job = RAILS_ENV == 'production'

	def after_create(robocall_list)
		if @@delayed_job == true
			Delayed::Job.enqueue RobocallListJob.new(robocall_list.id)
		else
			Delayed::Job.enqueue RobocallListJob.new(robocall_list.id)
			#robocall_list.populate
		end
	end	

	def after_update(robocall_list)
		return true unless robocall_list.repopulate == true
		#if @@delayed_job == true
			Delayed::Job.enqueue RobocallListJob.new(robocall_list.id)
		#else
		#	walksheet.populate
		#end
	end	

end

