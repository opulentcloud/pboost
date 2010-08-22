class StateCampaignsController < ApplicationController
	before_filter :require_user
	filter_access_to :all
	ssl_required :index, :show, :new, :create, :edit, :destroy
	
	layout 'admin'

  def index
  	pg = params[:page] ||= 1
    @state_campaigns = StateCampaign.paginate :page => pg, :per_page => 10
  end
  
  def show
    @state_campaign = StateCampaign.find(params[:id])
    @contact_lists = @state_campaign.contact_lists
  end
  
  def new
    @state_campaign = StateCampaign.new
  end
  
  def create
    @state_campaign = StateCampaign.new(params[:political_campaign])
    if @state_campaign.save
      flash[:notice] = "Successfully created political campaign."
      redirect_to @state_campaign
    else
      render :action => 'new'
    end
  end
  
  def edit
    @state_campaign = StateCampaign.find(params[:id])
  end
  
  def update
    @state_campaign = StateCampaign.find(params[:id])
    if @state_campaign.update_attributes(params[:political_campaign])
      flash[:notice] = "Successfully updated political campaign."
      redirect_to @state_campaign
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @state_campaign = StateCampaign.find(params[:id])
    @state_campaign.destroy
    flash[:notice] = "Successfully destroyed political campaign."
    redirect_to political_campaigns_url
  end
end
