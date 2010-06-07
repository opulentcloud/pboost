class MunicipalCampaignsController < ApplicationController
	before_filter :require_user
	filter_access_to :all

	layout 'admin'

  def index
  	pg = params[:page] ||= 1
    @municipal_campaigns = MunicipalCampaign.paginate :page => pg, :per_page => 10
  end
  
  def show
    @municipal_campaign = MunicipalCampaign.find(params[:id])
  end
  
  def new
    @municipal_campaign = MunicipalCampaign.new
  end
  
  def create
    @municipal_campaign = MunicipalCampaign.new(params[:municipal_campaign])
    if @municipal_campaign.save
      flash[:notice] = "Successfully created political campaign."
      redirect_to @municipal_campaign
    else
      render :action => 'new'
    end
  end
  
  def edit
    @municipal_campaign = MunicipalCampaign.find(params[:id])
  end
  
  def update
    @municipal_campaign = MunicipalCampaign.find(params[:id])
    if @municipal_campaign.update_attributes(params[:municipal_campaign])
      flash[:notice] = "Successfully updated political campaign."
      redirect_to @municipal_campaign
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @municipal_campaign = MunicipalCampaign.find(params[:id])
    @municipal_campaign.destroy
    flash[:notice] = "Successfully destroyed political campaign."
    redirect_to political_campaigns_url
  end
end
