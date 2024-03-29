class WalksheetsController < ApplicationController
	before_filter :require_user
	before_filter :get_walksheet, :only => [:show, :edit, :update, :destroy]
	filter_access_to :all
	ssl_required :index, :show, :new, :create, :edit, :destroy

  def index
    @walksheets = current_political_campaign.walksheets.all(:order => 'contact_lists.created_at DESC')
  end
  
  def show
  end
  
  def new
		if current_political_campaign.populated == false
			flash[:error] = 'You can not add Canvass Lists until we have finished populating your Political Campaign Voters'
			redirect_to walksheets_path
			return
		end

		@sess_id = UUIDTools::UUID.timestamp_create  
		
    @walksheet = current_political_campaign.walksheets.build
    @gis_region = @walksheet.build_gis_region
    @walksheet.build_age_filter
    @walksheet.build_sex_filter
    @walksheet.build_gis_region_filter
    @walksheet.build_council_district_filter
    @walksheet.build_municipal_district_filter
    @walksheet.build_precinct_filter
		@walksheet.build_voting_history_type_filter
  end
  
  def create
    @walksheet = Walksheet.new(params[:walksheet])

   	vh_filters = params[:voting_history_filter_attributes][:string_val].to_a unless params[:voting_history_filter_attributes].nil?

    @walksheet.elections.each_with_index do |e,index|
			a = vh_filters[index]
			next if a.nil?
			if a[0].to_i == e.id
				@walksheet.voting_history_filters.build(:int_val => e.id, :string_val => a[1])
			end			
	  end

		@walksheet.political_campaign_id = current_political_campaign.id

	  if @walksheet.save
	    flash[:notice] = "Successfully created Canvass List."
			respond_to do |format|
				format.html { redirect_to @walksheet }
				format.js
			end
	  else
		  @walksheet.build_age_filter if @walksheet.age_filter.nil?
		  @walksheet.build_sex_filter if @walksheet.sex_filter.nil?
		  @walksheet.build_gis_region_filter if @walksheet.gis_region_filter.nil?
		  @walksheet.build_council_district_filter if @walksheet.council_district_filter.nil?
		  @walksheet.build_precinct_filter if 		  @walksheet.precinct_filter.nil?
    @walksheet.build_municipal_district_filter if     @walksheet.municipal_district_filter.nil?
			@walksheet.build_voting_history_type_filter if @walksheet.voting_history_type_filter.nil?

			respond_to do |format|
      	format.html { render :action => 'new' }
				format.js { 
					flash.now[:error] = @walksheet.errors
					if @walksheet.errors.nil?
						flash.now[:error] = @walksheet.errors.add_to_base('Your Canvass List could not be created at this time.')
					end
					logger.debug(flash[:error].each_full { |msg| msg }.join('\n'))
					render :action => 'new' 
				}
    	end
	  end
  end
  
  def edit
  	if !@walksheet.is_editable?
  		flash[:notice] = 'You can not edit this Canvass List while it is being populated.'
  		redirect_to @walksheet
  	end
    @walksheet.build_age_filter if @walksheet.age_filter.nil?
    @walksheet.build_sex_filter if @walksheet.sex_filter.nil?
    @walksheet.build_gis_region_filter if @walksheet.gis_region_filter.nil?
    @walksheet.build_council_district_filter if @walksheet.council_district_filter.nil?
    @walksheet.build_precinct_filter if @walksheet.precinct_filter.nil?
@walksheet.build_municipal_district_filter if     @walksheet.municipal_district_filter.nil?
			@walksheet.build_voting_history_type_filter if @walksheet.voting_history_type_filter.nil?    
  end
  
  def update
		Walksheet.transaction do
			if params[:walksheet][:party_ids].nil?
				@walksheet.party_filters.destroy_all  	
			end

			if params[:walksheet][:election_ids].nil?
				@walksheet.voting_history_filters.destroy_all
			end
			#debugger
			if @walksheet.update_attributes(params[:walksheet])
			 	vh_filters = params[:voting_history_filter_attributes][:string_val].to_a unless params[:voting_history_filter_attributes].nil?
				
				vh_filters.each do |id,value|
					d = @walksheet.voting_history_filters.find_by_int_val(id)
					if d
						d.string_val = value
						d.save
					end
				end unless vh_filters.nil?

				@walksheet.voting_history_filters.each do |vh|
					vh.destroy if vh.string_val.nil?
				end

				if @walksheet.voting_history_type_filter
					@walksheet.voting_history_type_filter = nil if @walksheet.voting_history_filters.size == 0
				end

				@walksheet.repopulate = true
				@walksheet.constituent_count = nil
				@walksheet.populated = false
				@walksheet.save
				
			  flash[:notice] = "Successfully updated Canvass List."
			  redirect_to @walksheet
			else
				@walksheet.build_age_filter if @walksheet.age_filter.nil?
				@walksheet.build_sex_filter if @walksheet.sex_filter.nil?
				@walksheet.build_gis_region_filter if @walksheet.gis_region_filter.nil?
				@walksheet.build_council_district_filter if @walksheet.council_district_filter.nil?
				@walksheet.build_precinct_filter if @walksheet.precinct_filter.nil?
@walksheet.build_municipal_district_filter if     @walksheet.municipal_district_filter.nil?
			@walksheet.build_voting_history_type_filter if @walksheet.voting_history_type_filter.nil?
			  render :action => 'edit'
			end
		end
  end
  
  def destroy
  	if !@walksheet.is_editable?
  		flash[:notice] = 'You can not delete this Canvass List while it is being populated.'
  		redirect_to @walksheet
  		return
  	end
    @walksheet.destroy
    flash[:notice] = "Successfully deleted Canvass List."
    redirect_to walksheets_url
  end
  
private

	#get the walksheet for the current user
	def get_walksheet
		begin
    @walksheet = current_political_campaign.walksheets.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    	flash[:error] = "The requested Canvass List was not found."
    	redirect_back_or_default customer_control_panel_url
    end
	end

end
