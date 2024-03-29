class RobocallCampaignObserver < ActiveRecord::Observer

	@@delayed_job = RAILS_ENV == 'production'

	def after_create(robocall_campaign)
		if @@delayed_job == true
			AdminNotifier.send_later(:deliver_new_campaign_notification, robocall_campaign)
		else
			AdminNotifier.deliver_new_campaign_notification(robocall_campaign)
		end
	end	

	def after_update(robocall_campaign)
		return true unless robocall_campaign.changed? || robocall_campaign.live_answer_attachment.changed? || (!robocall_campaign.answer_machine_attachment.nil? && robocall_campaign.answer_machine_attachment.changed?)
		if @@delayed_job == true
			AdminNotifier.send_later(:deliver_updated_campaign_notification, robocall_campaign)
		else
			AdminNotifier.deliver_updated_campaign_notification(robocall_campaign)
		end
	end	

end

