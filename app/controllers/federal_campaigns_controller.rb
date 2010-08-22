class FederalCampaignsController < ApplicationController
	before_filter :require_user
	filter_access_to :all
	ssl_required :index, :show, :new, :create, :edit, :destroy
	
	layout 'admin'

  def index
  	pg = params[:page] ||= 1
    @federal_campaigns = FederalCampaign.paginate :page => pg, :per_page => 10
  end
  
  def show
    @federal_campaign = FederalCampaign.find(params[:id])
    @contact_lists = @federal_campaign.contact_lists
  end
  
  def new
    @federal_campaign = FederalCampaign.new
  end
  
  def create
    @federal_campaign = FederalCampaign.new(params[:political_campaign])
    if @federal_campaign.save
      flash[:notice] = "Successfully created political campaign."
      redirect_to @federal_campaign
    else
      render :action => 'new'
    end
  end
  
  def edit
    @federal_campaign = FederalCampaign.find(params[:id])
  end
  
  def update
    @federal_campaign = FederalCampaign.find(params[:id])
    if @federal_campaign.update_attributes(params[:political_campaign])
      flash[:notice] = "Successfully updated political campaign."
      redirect_to @federal_campaign
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @federal_campaign = FederalCampaign.find(params[:id])
    @federal_campaign.destroy
    flash[:notice] = "Successfully destroyed political campaign."
    redirect_to political_campaigns_url
  end
end
