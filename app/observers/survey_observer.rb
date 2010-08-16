class SurveyObserver < ActiveRecord::Observer

	@@delayed_job = RAILS_ENV == 'production'

	def after_create(survey)
		if @@delayed_job == true
			Delayed::Job.enqueue SurveyJob.new(survey.id)
		else
			Delayed::Job.enqueue SurveyJob.new(survey.id)
			#sms_list.populate
		end
	end	

	def after_update(survey)
		return true unless survey.repopulate == true
		#if @@delayed_job == true
			Delayed::Job.enqueue SurveyJob.new(survey.id)
		#else
		#	walksheet.populate
		#end
	end	

end

