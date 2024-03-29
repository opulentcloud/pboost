class SmsListsController < ApplicationController
	before_filter :require_user
	before_filter :get_sms_list, :only => [:map_fields, :show, :edit, :update, :destroy]
	filter_access_to :all
	ssl_required :map_fields, :intro, :index, :show, :new, :create, :edit, :destroy
	
	def map_fields
		@mapped_fields = { }
		@mapped_fields_string = '{ '
		@rows = @sms_list.rows
		@fields = [['',''],['Cell Phone', 'cell_phone']]

		if request.post?
			@have_selection = false
			params[:fields].each do |key,value|
				next if value.blank?
				@have_selection = true
				break;
			end

			if @have_selection == false
				flash.now[:error] = "You must choose the column that represents your Cell Phone field in the drop-down list for the appropriate column."
				render
				return
			end

			params[:fields].each do |key,value|
				if !value.blank? && @mapped_fields.has_key?(value.to_sym)
					flash.now[:error] = "We could not import your file because you have selected the field #{value} for two different columns. &nbsp;Only one column must be selected as the 'Cell Phone' field for the field mapping to be valid."
					render
					return
				end
				unless value.blank?
					@mapped_fields.store(value.to_sym, (key.to_i-1))
					@mapped_fields_string += ":#{value} => #{(key.to_i-1)}, "
				end
			end

			@mapped_fields_string = @mapped_fields_string[0,@mapped_fields_string.size-2] + " }" unless @mapped_fields_string.size == 0

			#ensure we mapped the field to a column number
			begin
				i = Integer(@mapped_fields[:cell_phone])
			rescue 
				flash.now[:error] = "We were not able to successfully map your fields and import your file. &nbsp;Please contact us if your need further assistance."
				render
				return
			end

			#mapped successfully let's import the file now.
			@sms_list.mapped_fields = @mapped_fields_string
			@sms_list.repopulate = true

			if @sms_list.save
				flash[:notice] = "Import in progress."			
				redirect_to @sms_list
			else
				flash.now[:error] = "We were not able to import your file at this time."
			end
		end

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
    @sms_list.build_sms_list_attachment
    @sms_list.upload_list = true
    @sms_list.do_mapping = true
    
  end

	def intro
    @intro_list = SmsList.new(params[:sms_list])

		if @intro_list.upload_list.nil?
			flash.now[:error] = 'You must choose YES or NO below.'
			@sms_list = @intro_list
			render :action => 'new'
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
	  @sms_list.build_sms_list_attachment

		@sms_list.upload_list = @intro_list.upload_list
		@sms_list.do_mapping = @sms_list.upload_list
		render :action => 'new'

	end
  
  def create
    @sms_list = SmsList.new(params[:sms_list])
		have_file = true

		if params[:sms_list][:sms_list_attachment_attributes].blank?
			@sms_list.errors.add_to_base('You must attach your file to continue.')
			have_file = false		
		end

   	vh_filters = params[:voting_history_filter_attributes][:string_val].to_a unless params[:voting_history_filter_attributes].nil?

    @sms_list.elections.each_with_index do |e,index|
			a = vh_filters[index]
			next if a.nil?
			if a[0].to_i == e.id
				@sms_list.voting_history_filters.build(:int_val => e.id, :string_val => a[1])
			end			
	  end

		@sms_list.political_campaign_id = current_political_campaign.id

	  if have_file && @sms_list.save
	  	if @sms_list.do_mapping == true
	  		#if we have just a single field then we are good to go
	  		#otherwise we have to ask the user which column is the
	  		#cell phone field.
	  		if @sms_list.need_mapping == true
	  			#render file for user to make mapping.
	  			redirect_to map_fields_sms_list_path(@sms_list)
	  			return
	  		end
	  	end
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
    	@sms_list.build_sms_list_attachment unless !@sms_list.sms_list_attachment.nil?

			if @sms_list.sms_list_attachment
				logger.debug(@sms_list.sms_list_attachment.content_type)
			else
				logger.debug("no attachment")
			end

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
  		flash[:error] = 'You can not edit this SMS List while it is being populated.'
  		redirect_to @sms_list
  	end
  	
  	if !@sms_list.status == 'n/a'
  		flash[:error] = "You can not edit this SMS List because the current status is #{@sms_list.status}."
  		redirect_to @sms_list
  	end
  	
    #@sms_list.build_age_filter if @sms_list.age_filter.nil?
    #@sms_list.build_sex_filter if @sms_list.sex_filter.nil?
    #@sms_list.build_gis_region_filter if @sms_list.gis_region_filter.nil?
    #@sms_list.build_council_district_filter if @sms_list.council_district_filter.nil?
    #@sms_list.build_precinct_filter if @sms_list.precinct_filter.nil?
#@sms_list.build_municipal_district_filter if     @sms_list.municipal_district_filter.nil?
			#@sms_list.build_voting_history_type_filter if @sms_list.voting_history_type_filter.nil?    
    	#@sms_list.build_sms_list_attachment unless !@sms_list.sms_list_attachment.nil?

  end
  
  def update
  	if !@sms_list.status == 'n/a'
  		flash[:error] = "You can not edit this SMS List because the current status is #{@sms_list.status}."
  		redirect_to @sms_list
  	end

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
    	@sms_list.build_sms_list_attachment unless !@sms_list.sms_list_attachment.nil?

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
    if @sms_list.destroy
	    flash[:notice] = "Successfully deleted SMS List."
	  else
	  	flash[:error] = 'This list could not be deleted.  It may be used in a Campaign - lists used in a campaign cannot be deleted (unless you first delete the campaign)'
	  end
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

