class RobocallCampaignObserver < ActiveRecord::Observer

	@@delayed_job = RAILS_ENV == 'production'

	def after_create(robocall_campaign)
		if @@delayed_job == true
			AdminNotifier.send_later(:deliver_new_campaign_notification, robocall_campaign)
			#Delayed::Job.enqueue RobocallCampaignJob.new(robocall_campaign.id)
		else
			#Delayed::Job.enqueue RobocallCampaignJob.new(robocall_campaign.id)
			#robocall_list.populate
		end
	end	

	def after_update(robocall_campaign)
		return true unless robocall_campaign.scheduled_at_changed?
			AdminNotifier.send_later(:deliver_rescheduled_campaign_notification, robocall_campaign)
		#if @@delayed_job == true
			#Delayed::Job.enqueue RobocallCampaignJob.new(robocall_campaign.id)
		#else
		#	walksheet.populate
		#end
	end	

end

