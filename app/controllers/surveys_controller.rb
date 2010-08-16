class SurveysController < ApplicationController
	before_filter :require_user
	before_filter :get_survey, :only => [:map_fields, :show, :edit, :update, :destroy]
	filter_access_to :all

	def map_fields
		@mapped_fields = { }
		@mapped_fields_string = '{ '
		@rows = @survey.rows
		@fields = [['',''],['State File ID', 'state_file_id']]

		@survey.questions.each do |question|
			@fields.push(["#{question.question_text}","#{question.id}"])
		end

		if request.post?
			@have_selection = false
			params[:fields].each do |key,value|
				next if value.blank?
				@have_selection = true
				break;
			end

			if @have_selection == false
				flash.now[:error] = "You must map each column to a field in our database."
				render
				return
			end

			params[:fields].each do |key,value|
				if !value.blank? && @mapped_fields.has_key?(value.to_sym)
					flash.now[:error] = "We could not import your file because you have selected the field #{key} for two different columns. &nbsp;Only one column must be selected as the '#{key}' field for the field mapping to be valid."
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
				i = Integer(@mapped_fields[:state_file_id])
			rescue 
				flash.now[:error] = "We were not able to successfully map your fields and import your file. &nbsp;Please contact us if your need further assistance."
				render
				return
			end

			#mapped successfully let's import the file now.
			@survey.mapped_fields = @mapped_fields_string
			@survey.repopulate = true

			if @survey.save
				flash[:notice] = "Import in progress."			
				redirect_to @survey
			else
				flash.now[:error] = "We were not able to import your file at this time."
			end
		end

	end

  def index
    @surveys = Surveys.all(:order => 'contact_lists.created_at DESC')
  end
  
  def show
  end
  
  def new
    @survey = Survey.new
    @survey.build_survey_attachment
		@survey.upload_list = true
		@survey.do_mapping = true
  end
  
  def create
    @survey = Survey.new(params[:survey])
		have_file = true

		if params[:survey][:survey_attachment_attributes].blank? && @survey.upload_list == true
			@survey.errors.add_to_base('You must attach your file to continue.')
			have_file = false		
		end

	  if have_file && @survey.save
	  	if @survey.do_mapping == true
	  		#if we have just a single field then we are good to go
	  		#otherwise we have to ask the user which column is the
	  		#which field.
	  		if @survey.need_mapping == true
	  			#render file for user to make mapping.
	  			redirect_to map_fields_survey_list_path(@survey)
	  			return
	  		end
	  	end
	    flash[:notice] = "Successfully created Survey."
			respond_to do |format|
				format.html { redirect_to @survey }
				format.js
			end
	  else
		  @survey.build_age_filter if @survey.age_filter.nil?
		  @survey.build_sex_filter if @survey.sex_filter.nil?
		  @survey.build_gis_region_filter if @survey.gis_region_filter.nil?
		  @survey.build_council_district_filter if @survey.council_district_filter.nil?
		  @survey.build_precinct_filter if 		  @survey.precinct_filter.nil?
    @survey.build_municipal_district_filter if     @survey.municipal_district_filter.nil?
			@survey.build_voting_history_type_filter if @survey.voting_history_type_filter.nil?
    	@survey.build_survey_attachment unless !@survey.survey_attachment.nil?

			respond_to do |format|
      	format.html { render :action => 'new' }
				format.js { 
					flash.now[:error] = @survey.errors
					if @survey.errors.nil?
						flash.now[:error] = @survey.errors.add_to_base('Your Survey could not be created at this time.')
					end
					logger.debug(flash[:error].each_full { |msg| msg }.join('\n'))
					render :action => 'new' 
				}
    	end
	  end
  end
  
  def edit
  	if !@survey.is_editable?
  		flash[:error] = 'You can not edit this Survey while it is being populated.'
  		redirect_to @survey
  	end
  	
  	if !@survey.status == 'n/a'
  		flash[:error] = "You can not edit this Survey because the current status is #{@survey.status}."
  		redirect_to @survey
  	end

  end
  
  def update
  	if !@survey.status == 'n/a'
  		flash[:error] = "You can not edit this Survey because the current status is #{@survey.status}."
  		redirect_to @survey
  	end

		if @survey.update_attributes(params[:survey])
			  flash[:notice] = "Successfully updated Survey."
			  redirect_to @survey
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
  	if !@survey.is_editable?
  		flash[:notice] = 'You can not delete this Survey while it is being populated.'
  		redirect_to @survey
  		return
  	end
    if @survey.destroy
	    flash[:notice] = "Successfully deleted Survey."
	  else
	  	flash[:error] = 'This Survey could not be deleted.  It may be used in a Campaign - Surveys used in a campaign cannot be deleted (unless you first delete the campaign)'
	  end
    redirect_to surveys_url
  end
  
private

	#get the Survey
	def get_survey
		begin
    @survey = Survey.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    	flash[:error] = "The requested Survey was not found."
    	redirect_back_or_default admin_control_panel_url
    end
	end

end

