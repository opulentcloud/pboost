class CampaignsController < ApplicationController
	before_filter :require_user
	before_filter :get_campaign, :only => [:show, :unschedule, :edit]
	filter_access_to :all
	ssl_required [:show, :unschedule, :create, :new, :index, :edit]

	def show
		case @campaign.class.to_s
			when 'RobocallCampaign' then
				redirect_to robocall_campaign_path(@campaign)
				return
		end
		flash[:error] = 'You can not display this Campaign'
		redirect_back_or_default campaigns_path
	end

	def unschedule
		case @campaign.class.to_s
			when 'RobocallCampaign' then
				redirect_to unschedule_robocall_campaign_path(@campaign)
				return
			when 'SmsCampaign' then
				redirect_to unschedule_sms_campaign_path(@campaign)
				return
		end
		flash[:error] = 'We could not unschedule this campaign.'
		redirect_to campaigns_path
	end

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

	def edit
		case @campaign.class.to_s
			when 'RobocallCampaign' then
				redirect_to edit_robocall_campaign_path(@campaign)
				return
			when 'SmsCampaign' then
				redirect_to edit_sms_campaign_path(@campaign)
				return
		end
		flash[:error] = 'You can not not edit this campaign.'
		redirect_to campaigns_path
	end

private
	#get the campaign
	def get_campaign
		begin
	    @campaign = current_political_campaign.campaigns.find(params[:id]) unless current_political_campaign.nil?
	    if current_political_campaign.nil? && current_user.is_admin?
		    @campaign = Campaign.find(params[:id])
		    session[:current_political_campaign] = @campaign.political_campaign
			end    
    rescue ActiveRecord::RecordNotFound
    	flash[:error] = "The requested Campaign was not found."
    	redirect_back_or_default customer_control_panel_url
    end
	end

end

