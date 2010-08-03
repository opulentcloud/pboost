class RobocallListsController < ApplicationController
	before_filter :require_user
	before_filter :get_robocall_list, :only => [:map_fields, :show, :edit, :update, :destroy]
	filter_access_to :all

	def map_fields
		@mapped_fields = { }
		@mapped_fields_string = '{ '
		@rows = @robocall_list.rows
		@fields = [['',''],['Phone Number', 'phone']]

		if request.post?
			@have_selection = false
			params[:fields].each do |key,value|
				next if value.blank?
				@have_selection = true
				break;
			end

			if @have_selection == false
				flash.now[:error] = "You must choose the column that represents your Phone Number field in the drop-down list for the appropriate column."
				render
				return
			end

			params[:fields].each do |key,value|
				if !value.blank? && @mapped_fields.has_key?(value.to_sym)
					flash.now[:error] = "We could not import your file because you have selected the field #{value} for two different columns. &nbsp;Only one column must be selected as the 'Phone Number' field for the field mapping to be valid."
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
				i = Integer(@mapped_fields[:phone])
			rescue 
				flash.now[:error] = "We were not able to successfully map your fields and import your file. &nbsp;Please contact us if your need further assistance."
				render
				return
			end

			#mapped successfully let's import the file now.
			@robocall_list.mapped_fields = @mapped_fields_string
			@robocall_list.repopulate = true

			if @robocall_list.save
				flash[:notice] = "Import in progress."			
				redirect_to @robocall_list
			else
				flash.now[:error] = "We were not able to import your file at this time."
			end
		end

	end

  def index
    @robocall_lists = current_political_campaign.robocall_lists.all(:order => 'contact_lists.created_at DESC')
  end
  
  def show
  end
  
  def new
		if current_political_campaign.populated == false
			flash[:error] = 'You can not add Robocall Lists until we have finished populating your Political Campaign Voters'
			redirect_to robocall_lists_path
			return
		end

		@sess_id = UUIDTools::UUID.timestamp_create  
		
    @robocall_list = current_political_campaign.robocall_lists.build
    @gis_region = @robocall_list.build_gis_region
    @robocall_list.build_age_filter
    @robocall_list.build_sex_filter
    @robocall_list.build_gis_region_filter
    @robocall_list.build_council_district_filter
    @robocall_list.build_municipal_district_filter
    @robocall_list.build_precinct_filter
		@robocall_list.build_voting_history_type_filter
    @robocall_list.build_robocall_list_attachment
    
  end

	def intro
    @intro_list = RobocallList.new(params[:robocall_list])

		if @intro_list.upload_list.nil?
			flash.now[:error] = 'You must choose YES or NO below.'
			@robocall_list = @intro_list
			render :action => 'new'
			return
		end

		@sess_id = UUIDTools::UUID.timestamp_create  

	  @robocall_list = current_political_campaign.robocall_lists.build
	  @gis_region = @robocall_list.build_gis_region
	  @robocall_list.build_age_filter
	  @robocall_list.build_sex_filter
	  @robocall_list.build_gis_region_filter
	  @robocall_list.build_council_district_filter
	  @robocall_list.build_municipal_district_filter
	  @robocall_list.build_precinct_filter
		@robocall_list.build_voting_history_type_filter
	  @robocall_list.build_robocall_list_attachment

		@robocall_list.upload_list = @intro_list.upload_list
		@robocall_list.do_mapping = @robocall_list.upload_list
		render :action => 'new'

	end
  
  def create
    @robocall_list = RobocallList.new(params[:robocall_list])
		have_file = true

		if params[:robocall_list][:robocall_list_attachment_attributes].blank? && @robocall_list.upload_list == true
			@robocall_list.errors.add_to_base('You must attach your file to continue.')
			have_file = false		
		end

   	vh_filters = params[:voting_history_filter_attributes][:string_val].to_a unless params[:voting_history_filter_attributes].nil?

    @robocall_list.elections.each_with_index do |e,index|
			a = vh_filters[index]
			next if a.nil?
			if a[0].to_i == e.id
				@robocall_list.voting_history_filters.build(:int_val => e.id, :string_val => a[1])
			end			
	  end

		@robocall_list.political_campaign_id = current_political_campaign.id

	  if have_file && @robocall_list.save
	  	if @robocall_list.do_mapping == true
	  		#if we have just a single field then we are good to go
	  		#otherwise we have to ask the user which column is the
	  		#phone number field.
	  		if @robocall_list.need_mapping == true
	  			#render file for user to make mapping.
	  			redirect_to map_fields_robocall_list_path(@robocall_list)
	  			return
	  		end
	  	end
	    flash[:notice] = "Successfully created Robocall List."
			respond_to do |format|
				format.html { redirect_to @robocall_list }
				format.js
			end
	  else
		  @robocall_list.build_age_filter if @robocall_list.age_filter.nil?
		  @robocall_list.build_sex_filter if @robocall_list.sex_filter.nil?
		  @robocall_list.build_gis_region_filter if @robocall_list.gis_region_filter.nil?
		  @robocall_list.build_council_district_filter if @robocall_list.council_district_filter.nil?
		  @robocall_list.build_precinct_filter if 		  @robocall_list.precinct_filter.nil?
    @robocall_list.build_municipal_district_filter if     @robocall_list.municipal_district_filter.nil?
			@robocall_list.build_voting_history_type_filter if @robocall_list.voting_history_type_filter.nil?
    	@robocall_list.build_robocall_list_attachment unless !@robocall_list.robocall_list_attachment.nil?

			respond_to do |format|
      	format.html { render :action => 'new' }
				format.js { 
					flash.now[:error] = @robocall_list.errors
					if @robocall_list.errors.nil?
						flash.now[:error] = @robocall_list.errors.add_to_base('Your Robocall List could not be created at this time.')
					end
					logger.debug(flash[:error].each_full { |msg| msg }.join('\n'))
					render :action => 'new' 
				}
    	end
	  end
  end
  
  def edit
  	if !@robocall_list.is_editable?
  		flash[:error] = 'You can not edit this Robocall List while it is being populated.'
  		redirect_to @robocall_list
  	end
  	
  	if !@robocall_list.status == 'n/a'
  		flash[:error] = "You can not edit this Robocall List because the current status is #{@robocall_list.status}."
  		redirect_to @robocall_list
  	end
  	
    #@robocall_list.build_age_filter if @robocall_list.age_filter.nil?
    #@robocall_list.build_sex_filter if @robocall_list.sex_filter.nil?
    #@robocall_list.build_gis_region_filter if @robocall_list.gis_region_filter.nil?
    #@robocall_list.build_council_district_filter if @robocall_list.council_district_filter.nil?
    #@robocall_list.build_precinct_filter if @robocall_list.precinct_filter.nil?
#@robocall_list.build_municipal_district_filter if     @robocall_list.municipal_district_filter.nil?
			#@robocall_list.build_voting_history_type_filter if @robocall_list.voting_history_type_filter.nil?    
    	#@robocall_list.build_robocall_list_attachment unless !@robocall_list.robocall_list_attachment.nil?

  end
  
  def update
  	if !@robocall_list.status == 'n/a'
  		flash[:error] = "You can not edit this Robocall List because the current status is #{@robocall_list.status}."
  		redirect_to @robocall_list
  	end

		@robocall_list.schedule = true

		if @robocall_list.update_attributes(params[:robocall_list])
			  flash[:notice] = "Successfully scheduled Robocall List For Delivery."
			  redirect_to @robocall_list
		else
			  render :action => 'edit'
		end

		if 1 == 0
		robocalllist.transaction do
			if params[:robocall_list][:party_ids].nil?
				@robocall_list.party_filters.destroy_all  	
			end

			if params[:robocall_list][:election_ids].nil?
				@robocall_list.voting_history_filters.destroy_all
			end
			#debugger
			if @robocall_list.update_attributes(params[:robocall_list])
			 	vh_filters = params[:voting_history_filter_attributes][:string_val].to_a unless params[:voting_history_filter_attributes].nil?
				
				vh_filters.each do |id,value|
					d = @robocall_list.voting_history_filters.find_by_int_val(id)
					if d
						d.string_val = value
						d.save
					end
				end unless vh_filters.nil?

				@robocall_list.voting_history_filters.each do |vh|
					vh.destroy if vh.string_val.nil?
				end

				if @robocall_list.voting_history_type_filter
					@robocall_list.voting_history_type_filter = nil if @robocall_list.voting_history_filters.size == 0
				end

				@robocall_list.repopulate = true
				@robocall_list.constituent_count = nil
				@robocall_list.populated = false
				@robocall_list.save
				
			  flash[:notice] = "Successfully updated Robocall List."
			  redirect_to @robocall_list
			else
				@robocall_list.build_age_filter if @robocall_list.age_filter.nil?
				@robocall_list.build_sex_filter if @robocall_list.sex_filter.nil?
				@robocall_list.build_gis_region_filter if @robocall_list.gis_region_filter.nil?
				@robocall_list.build_council_district_filter if @robocall_list.council_district_filter.nil?
				@robocall_list.build_precinct_filter if @robocall_list.precinct_filter.nil?
@robocall_list.build_municipal_district_filter if     @robocall_list.municipal_district_filter.nil?
			@robocall_list.build_voting_history_type_filter if @robocall_list.voting_history_type_filter.nil?
    	@robocall_list.build_robocall_list_attachment unless !@robocall_list.robocall_list_attachment.nil?

			  render :action => 'edit'
			end
		end
		end
  end
  
  def destroy
  	if !@robocall_list.is_editable?
  		flash[:notice] = 'You can not delete this Robocall List while it is being populated.'
  		redirect_to @robocall_list
  		return
  	end
    @robocall_list.destroy
    flash[:notice] = "Successfully deleted Robocall List."
    redirect_to robocall_lists_url
  end
  
private

	#get the robocall_list for the current user
	def get_robocall_list
		begin
    @robocall_list = current_political_campaign.robocall_lists.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    	flash[:error] = "The requested Robocall List was not found."
    	redirect_back_or_default customer_control_panel_url
    end
	end

end

