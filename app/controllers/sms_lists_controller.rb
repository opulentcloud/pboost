class SmsListsController < ApplicationController
	before_filter :require_user
	before_filter :get_sms_list, :only => [:unschedule, :show, :edit, :update, :destroy]
	filter_access_to :all

	def unschedule
		if @sms_list.status != 'Scheduled'
			flash[:error] = "We could not cancel the sending of this list because the current status is #{@sms_list.status}."
		else
			@sms_list.schedule = false
			@sms_list.scheduled_at = nil
			if @sms_list.save
				flash[:notice] = 'Unschedule was successful.'
			else
				flash[:error] = 'We could not unschedule at this time.'
			end
		end
		redirect_back_or_default sms_lists_path
	end

  def index
    @sms_lists = current_political_campaign.sms_lists.all(:order => 'contact_lists.created_at DESC')
  end
  
  def show
  end
  
  def new
		if current_political_campaign.populated == false
			flash[:error] = 'You can not add SMS Lists until we have finished populating your Political Campaign Voters'
			redirect_to sms_lists_path
			return
		end

		@sess_id = UUIDTools::UUID.timestamp_create  
		
    @sms_list = current_political_campaign.sms_lists.build
    @gis_region = @sms_list.build_gis_region
    @sms_list.build_age_filter
    @sms_list.build_sex_filter
    @sms_list.build_gis_region_filter
    @sms_list.build_council_district_filter
    @sms_list.build_municipal_district_filter
    @sms_list.build_precinct_filter
		@sms_list.build_voting_history_type_filter
  end
  
  def create
    @sms_list = SmsList.new(params[:sms_list])

   	vh_filters = params[:voting_history_filter_attributes][:string_val].to_a unless params[:voting_history_filter_attributes].nil?

    @sms_list.elections.each_with_index do |e,index|
			a = vh_filters[index]
			next if a.nil?
			if a[0].to_i == e.id
				@sms_list.voting_history_filters.build(:int_val => e.id, :string_val => a[1])
			end			
	  end

		@sms_list.political_campaign_id = current_political_campaign.id

	  if @sms_list.save
	    flash[:notice] = "Successfully created SMS List."
			respond_to do |format|
				format.html { redirect_to @sms_list }
				format.js
			end
	  else
		  @sms_list.build_age_filter if @sms_list.age_filter.nil?
		  @sms_list.build_sex_filter if @sms_list.sex_filter.nil?
		  @sms_list.build_gis_region_filter if @sms_list.gis_region_filter.nil?
		  @sms_list.build_council_district_filter if @sms_list.council_district_filter.nil?
		  @sms_list.build_precinct_filter if 		  @sms_list.precinct_filter.nil?
    @sms_list.build_municipal_district_filter if     @sms_list.municipal_district_filter.nil?
			@sms_list.build_voting_history_type_filter if @sms_list.voting_history_type_filter.nil?

			respond_to do |format|
      	format.html { render :action => 'new' }
				format.js { 
					flash.now[:error] = @sms_list.errors
					if @sms_list.errors.nil?
						flash.now[:error] = @sms_list.errors.add_to_base('Your SMS List could not be created at this time.')
					end
					logger.debug(flash[:error].each_full { |msg| msg }.join('\n'))
					render :action => 'new' 
				}
    	end
	  end
  end
  
  def edit
  	if !@sms_list.is_editable?
  		flash[:notice] = 'You can not edit this SMS List while it is being populated.'
  		redirect_to @sms_list
  	end
    @sms_list.build_age_filter if @sms_list.age_filter.nil?
    @sms_list.build_sex_filter if @sms_list.sex_filter.nil?
    @sms_list.build_gis_region_filter if @sms_list.gis_region_filter.nil?
    @sms_list.build_council_district_filter if @sms_list.council_district_filter.nil?
    @sms_list.build_precinct_filter if @sms_list.precinct_filter.nil?
@sms_list.build_municipal_district_filter if     @sms_list.municipal_district_filter.nil?
			@sms_list.build_voting_history_type_filter if @sms_list.voting_history_type_filter.nil?    
  end
  
  def update
		@sms_list.schedule = true
		if @sms_list.update_attributes(params[:sms_list])
			  flash[:notice] = "Successfully scheduled SMS List For Delivery."
			  redirect_to @sms_list
		else
			  render :action => 'edit'
		end

		if 1 == 0
		Smslist.transaction do
			if params[:sms_list][:party_ids].nil?
				@sms_list.party_filters.destroy_all  	
			end

			if params[:sms_list][:election_ids].nil?
				@sms_list.voting_history_filters.destroy_all
			end
			#debugger
			if @sms_list.update_attributes(params[:sms_list])
			 	vh_filters = params[:voting_history_filter_attributes][:string_val].to_a unless params[:voting_history_filter_attributes].nil?
				
				vh_filters.each do |id,value|
					d = @sms_list.voting_history_filters.find_by_int_val(id)
					if d
						d.string_val = value
						d.save
					end
				end unless vh_filters.nil?

				@sms_list.voting_history_filters.each do |vh|
					vh.destroy if vh.string_val.nil?
				end

				if @sms_list.voting_history_type_filter
					@sms_list.voting_history_type_filter = nil if @sms_list.voting_history_filters.size == 0
				end

				@sms_list.repopulate = true
				@sms_list.constituent_count = nil
				@sms_list.populated = false
				@sms_list.save
				
			  flash[:notice] = "Successfully updated SMS List."
			  redirect_to @sms_list
			else
				@sms_list.build_age_filter if @sms_list.age_filter.nil?
				@sms_list.build_sex_filter if @sms_list.sex_filter.nil?
				@sms_list.build_gis_region_filter if @sms_list.gis_region_filter.nil?
				@sms_list.build_council_district_filter if @sms_list.council_district_filter.nil?
				@sms_list.build_precinct_filter if @sms_list.precinct_filter.nil?
@sms_list.build_municipal_district_filter if     @sms_list.municipal_district_filter.nil?
			@sms_list.build_voting_history_type_filter if @sms_list.voting_history_type_filter.nil?
			  render :action => 'edit'
			end
		end
		end
  end
  
  def destroy
  	if !@sms_list.is_editable?
  		flash[:notice] = 'You can not delete this SMS List while it is being populated.'
  		redirect_to @sms_list
  		return
  	end
    @sms_list.destroy
    flash[:notice] = "Successfully deleted SMS List."
    redirect_to sms_lists_url
  end
  
private

	#get the sms_list for the current user
	def get_sms_list
		begin
    @sms_list = current_political_campaign.sms_lists.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    	flash[:error] = "The requested SMS List was not found."
    	redirect_back_or_default customer_control_panel_url
    end
	end

end

