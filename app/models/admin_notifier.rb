class AdminNotifier < ActionMailer::Base
	helper :application
	
	@@from_email = 'PBOOST <dls@politicalboost.org>'
	if RAILS_ENV == 'Production'
		@@admin_email = ['Desmond Stinnie <dls@politicalboost.org>', 'Mark Wilson <mark@wilsonsdev.com>']
	else
		@@admin_email = ['Mark Wilson <mark@wilsonsdev.com>']
	end

	def new_campaign_notification(campaign)
		subject			'New Robocall Campaign Scheduled Notification'
		from				@@from_email
		recipients	@@admin_email
		sent_on			Time.zone.now
		body				:campaign => campaign, :organization => campaign.political_campaign.organization, :political_campaign => campaign.political_campaign
		content_type	'text/plain'		
	end

end
