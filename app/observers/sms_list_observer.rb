class SmsListObserver < ActiveRecord::Observer

	@@delayed_job = RAILS_ENV == 'production'

	def after_create(sms_list)
		if @@delayed_job == true
			Delayed::Job.enqueue SmsListJob.new(sms_list.id)
		else
			sms_list.populate
		end
	end	

	def after_update(sms_list)
		return true unless sms_list.repopulate == true
		#if @@delayed_job == true
			Delayed::Job.enqueue SmsListJob.new(sms_list.id)
		#else
		#	walksheet.populate
		#end
	end	

end

