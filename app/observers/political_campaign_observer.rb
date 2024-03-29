class PoliticalCampaignObserver < ActiveRecord::Observer

	@@delayed_job = RAILS_ENV == 'production'

	def after_create(political_campaign)
		if @@delayed_job == true
			Delayed::Job.enqueue PoliticalCampaignJob.new(political_campaign.id)
		else
			PoliticalCampaign.populate_constituents(political_campaign.id)
		end
	end	

	def after_update(political_campaign)
		return true unless political_campaign.repopulate == true
		#if @@delayed_job == true
			Delayed::Job.enqueue PoliticalCampaignJob.new(political_campaign.id)
		#else
		#	PoliticalCampaign.populate_constituents(political_campaign.id)
		#end
	end	

end

