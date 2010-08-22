class OrganizationsController < ApplicationController
	before_filter :require_user
	filter_access_to :all
	ssl_required :index, :show, :new, :create, :edit, :update, :destroy

	layout 'admin'

  def index
  	pg = params[:page] ||= 1
    @organizations = Organization.paginate :page => pg, :per_page => 20
    
  end
  
  def show
    @organization = Organization.find(params[:id])
    @users = @organization.users.paginate :page => 1, :per_page => 99999
    @political_campaigns = @organization.political_campaigns
  end
  
  def new
    @organization = Organization.new
  end
  
  def create
    @organization = Organization.new(params[:organization])
    if @organization.save
      flash[:notice] = "Successfully created organization."
      redirect_to @organization
    else
      render :action => 'new'
    end
  end
  
  def edit
    @organization = Organization.find(params[:id])
  end
  
  def update
    @organization = Organization.find(params[:id])
    if @organization.update_attributes(params[:organization])
      flash[:notice] = "Successfully updated organization."
      redirect_to @organization
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy
    flash[:notice] = "Successfully destroyed organization."
    redirect_to organizations_url
  end
end
