class SmsCampaignObserver < ActiveRecord::Observer

	@@delayed_job = RAILS_ENV == 'production'

	def after_create(sms_campaign)
		if @@delayed_job == true
			Delayed::Job.enqueue SmsCampaignJob.new(sms_campaign.id)
		else
			Delayed::Job.enqueue SmsCampaignJob.new(sms_campaign.id)
			#sms_list.populate
		end
	end	

	def after_update(sms_campaign)
		return true unless sms_campaign.repopulate == true
		#if @@delayed_job == true
			Delayed::Job.enqueue SmsCampaignJob.new(sms_campaign.id)
		#else
		#	walksheet.populate
		#end
	end	

end

