class WalksheetsController < ApplicationController
	before_filter :require_user
	before_filter :get_walksheet, :only => [:show, :edit, :update, :destroy]
	filter_access_to :all

  def index
    @walksheets = current_political_campaign.walksheets.all
  end
  
  def show
  end
  
  def new
		if current_political_campaign.populated == false
			flash[:error] = 'You can not add Walk Sheets until we have finished populating your Political Campaign Constituents'
			redirect_to walksheets_path
			return
		end
  
    @walksheet = current_political_campaign.walksheets.build
    @walksheet.build_age_filter
    @walksheet.build_sex_filter
    @walksheet.build_gis_region_filter
    @walksheet.build_council_district_filter
    @walksheet.build_precinct_filter
  end
  
  def create
    @walksheet = Walksheet.new(params[:walksheet])
		@walksheet.political_campaign_id = current_political_campaign.id
	  if @walksheet.save
	    flash[:notice] = "Successfully created walksheet."
	    redirect_to @walksheet
	  else
	    render :action => 'new'
	  end
  end
  
  def edit
  	if !@walksheet.is_editable?
  		flash[:notice] = 'You can not edit this Walk Sheet while it is being populated.'
  		redirect_to @walksheet
  	end
    @walksheet.build_age_filter if @walksheet.age_filter.nil?
    @walksheet.build_sex_filter if @walksheet.sex_filter.nil?
    @walksheet.build_gis_region_filter if @walksheet.gis_region_filter.nil?
    @walksheet.build_council_district_filter if @walksheet.council_district_filter.nil?
    @walksheet.build_precinct_filter if @walksheet.precinct_filter.nil?
  end
  
  def update
  	if params[:walksheet][:party_ids].nil?
			@walksheet.party_filters.destroy_all  	
  	end
  	
	  if @walksheet.update_attributes(params[:walksheet])
	    flash[:notice] = "Successfully updated walksheet."
	    redirect_to @walksheet
	  else
		  @walksheet.build_age_filter if @walksheet.age_filter.nil?
		  @walksheet.build_sex_filter if @walksheet.sex_filter.nil?
		  @walksheet.build_gis_region_filter if @walksheet.gis_region_filter.nil?
		  @walksheet.build_council_district_filter if @walksheet.council_district_filter.nil?
		  @walksheet.build_precinct_filter if @walksheet.precinct_filter.nil?

	    render :action => 'edit'
	  end
  end
  
  def destroy
  	if !@walksheet.is_editable?
  		flash[:notice] = 'You can not delete this Walk Sheet while it is being populated.'
  		redirect_to @walksheet
  		return
  	end
    @walksheet.destroy
    flash[:notice] = "Successfully destroyed walksheet."
    redirect_to walksheets_url
  end
  
private

	#get the walksheet for the current user
	def get_walksheet
		begin
    @walksheet = current_political_campaign.walksheets.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    	flash[:error] = "The requested Walk Sheet was not found."
    	redirect_back_or_default customer_control_panel_url
    end
	end

end
