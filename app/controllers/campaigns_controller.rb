class CampaignsController < ApplicationController
	before_filter :require_user
	filter_access_to :all

	def create
		params[:campaign] ||= { :campaign => { :type => '' } }
						
		case params[:campaign][:type]
			when 'RobocallCampaign' then
				redirect_to new_robocall_campaign_path
			when 'SmsCampaign' then
				redirect_to new_sms_campaign_path
			else
				flash[:error] = 'You must choose a valid Campaign Type.'
				@campaign = current_political_campaign.campaigns.build
				render :action => 'new'
		end
	end

	def new
		@campaign = current_political_campaign.campaigns.build
	end

  def index
    @campaigns = current_political_campaign.campaigns.all(:order => 'campaigns.created_at DESC')
  end

end

