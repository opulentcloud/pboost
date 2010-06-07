class CountyCampaignsController < ApplicationController
	before_filter :require_user
	filter_access_to :all

	layout 'admin'

  def index
  	pg = params[:page] ||= 1
    @county_campaigns = CountyCampaign.paginate :page => pg, :per_page => 10
  end
  
  def show
    @county_campaign = CountyCampaign.find(params[:id])
  end
  
  def new
    @county_campaign = CountyCampaign.new
  end
  
  def create
    @county_campaign = CountyCampaign.new(params[:county_campaign])
    if @county_campaign.save
      flash[:notice] = "Successfully created political campaign."
      redirect_to @county_campaign
    else
      render :action => 'new'
    end
  end
  
  def edit
    @county_campaign = CountyCampaign.find(params[:id])
  end
  
  def update
    @county_campaign = CountyCampaign.find(params[:id])
    if @county_campaign.update_attributes(params[:county_campaign])
      flash[:notice] = "Successfully updated political campaign."
      redirect_to @county_campaign
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @county_campaign = CountyCampaign.find(params[:id])
    @county_campaign.destroy
    flash[:notice] = "Successfully destroyed political campaign."
    redirect_to political_campaigns_url
  end
end
