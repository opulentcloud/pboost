class PoliticalCampaignsController < ApplicationController
	before_filter :require_user
	filter_access_to :all

	layout 'admin'

  def index
  	pg = params[:page] ||= 1
    @political_campaigns = PoliticalCampaign.paginate :page => pg, :per_page => 10
  end
  
  def show
    @political_campaign = PoliticalCampaign.find(params[:id])
  end
  
  def new
    @political_campaign = PoliticalCampaign.new
  end
  
  def create
    @political_campaign = PoliticalCampaign.new(params[:political_campaign])
    if @political_campaign.save
      flash[:notice] = "Successfully created political campaign."
      redirect_to @political_campaign
    else
      render :action => 'new'
    end
  end
  
  def edit
    @political_campaign = PoliticalCampaign.find(params[:id])
  end
  
  def update
    @political_campaign = PoliticalCampaign.find(params[:id])
    if @political_campaign.update_attributes(params[:political_campaign])
      flash[:notice] = "Successfully updated political campaign."
      redirect_to @political_campaign
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @political_campaign = PoliticalCampaign.find(params[:id])
    @political_campaign.destroy
    flash[:notice] = "Successfully destroyed political campaign."
    redirect_to political_campaigns_url
  end
end
