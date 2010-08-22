class PhoneBankListsController < ApplicationController
	before_filter :require_user
	before_filter :get_phone_bank_list, :only => [:show, :edit, :update, :destroy]
	filter_access_to :all
	ssl_required :index, :show, :new, :create, :edit, :destroy
	
  def index
    @phone_bank_lists = current_political_campaign.phone_bank_lists.all(:order => 'contact_lists.created_at DESC')
  end
  
  def show
  end
  
  def new
		if current_political_campaign.populated == false
			flash[:error] = 'You can not add Phone Bank Lists until we have finished populating your Political Campaign Voters'
			redirect_to phone_bank_lists_path
			return
		end

		@sess_id = UUIDTools::UUID.timestamp_create  
		
    @phone_bank_list = current_political_campaign.phone_bank_lists.build
    @gis_region = @phone_bank_list.build_gis_region
    @phone_bank_list.build_age_filter
    @phone_bank_list.build_sex_filter
    @phone_bank_list.build_gis_region_filter
    @phone_bank_list.build_council_district_filter
    @phone_bank_list.build_municipal_district_filter
    @phone_bank_list.build_precinct_filter
		@phone_bank_list.build_voting_history_type_filter
  end
  
  def create
    @phone_bank_list = PhoneBankList.new(params[:phone_bank_list])

   	vh_filters = params[:voting_history_filter_attributes][:string_val].to_a unless params[:voting_history_filter_attributes].nil?

    @phone_bank_list.elections.each_with_index do |e,index|
			a = vh_filters[index]
			next if a.nil?
			if a[0].to_i == e.id
				@phone_bank_list.voting_history_filters.build(:int_val => e.id, :string_val => a[1])
			end			
	  end

		@phone_bank_list.political_campaign_id = current_political_campaign.id

	  if @phone_bank_list.save
	    flash[:notice] = "Successfully created Phone Bank List."
			respond_to do |format|
				format.html { redirect_to @phone_bank_list }
				format.js
			end
	  else
		  @phone_bank_list.build_age_filter if @phone_bank_list.age_filter.nil?
		  @phone_bank_list.build_sex_filter if @phone_bank_list.sex_filter.nil?
		  @phone_bank_list.build_gis_region_filter if @phone_bank_list.gis_region_filter.nil?
		  @phone_bank_list.build_council_district_filter if @phone_bank_list.council_district_filter.nil?
		  @phone_bank_list.build_precinct_filter if 		  @phone_bank_list.precinct_filter.nil?
    @phone_bank_list.build_municipal_district_filter if     @phone_bank_list.municipal_district_filter.nil?
			@phone_bank_list.build_voting_history_type_filter if @phone_bank_list.voting_history_type_filter.nil?

			respond_to do |format|
      	format.html { render :action => 'new' }
				format.js { 
					flash.now[:error] = @phone_bank_list.errors
					if @phone_bank_list.errors.nil?
						flash.now[:error] = @phone_bank_list.errors.add_to_base('Your Phone Bank List could not be created at this time.')
					end
					logger.debug(flash[:error].each_full { |msg| msg }.join('\n'))
					render :action => 'new' 
				}
    	end
	  end
  end
  
  def edit
  	if !@phone_bank_list.is_editable?
  		flash[:notice] = 'You can not edit this Phone Bank List while it is being populated.'
  		redirect_to @phone_bank_list
  	end
    @phone_bank_list.build_age_filter if @phone_bank_list.age_filter.nil?
    @phone_bank_list.build_sex_filter if @phone_bank_list.sex_filter.nil?
    @phone_bank_list.build_gis_region_filter if @phone_bank_list.gis_region_filter.nil?
    @phone_bank_list.build_council_district_filter if @phone_bank_list.council_district_filter.nil?
    @phone_bank_list.build_precinct_filter if @phone_bank_list.precinct_filter.nil?
@phone_bank_list.build_municipal_district_filter if     @phone_bank_list.municipal_district_filter.nil?
			@phone_bank_list.build_voting_history_type_filter if @phone_bank_list.voting_history_type_filter.nil?    
  end
  
  def update
		phone_bank_list.transaction do
			if params[:phone_bank_list][:party_ids].nil?
				@phone_bank_list.party_filters.destroy_all  	
			end

			if params[:phone_bank_list][:election_ids].nil?
				@phone_bank_list.voting_history_filters.destroy_all
			end
			#debugger
			if @phone_bank_list.update_attributes(params[:phone_bank_list])
			 	vh_filters = params[:voting_history_filter_attributes][:string_val].to_a unless params[:voting_history_filter_attributes].nil?
				
				vh_filters.each do |id,value|
					d = @phone_bank_list.voting_history_filters.find_by_int_val(id)
					if d
						d.string_val = value
						d.save
					end
				end unless vh_filters.nil?

				@phone_bank_list.voting_history_filters.each do |vh|
					vh.destroy if vh.string_val.nil?
				end

				if @phone_bank_list.voting_history_type_filter
					@phone_bank_list.voting_history_type_filter = nil if @phone_bank_list.voting_history_filters.size == 0
				end

				@phone_bank_list.repopulate = true
				@phone_bank_list.constituent_count = nil
				@phone_bank_list.populated = false
				@phone_bank_list.save
				
			  flash[:notice] = "Successfully updated Phone Bank List."
			  redirect_to @phone_bank_list
			else
				@phone_bank_list.build_age_filter if @phone_bank_list.age_filter.nil?
				@phone_bank_list.build_sex_filter if @phone_bank_list.sex_filter.nil?
				@phone_bank_list.build_gis_region_filter if @phone_bank_list.gis_region_filter.nil?
				@phone_bank_list.build_council_district_filter if @phone_bank_list.council_district_filter.nil?
				@phone_bank_list.build_precinct_filter if @phone_bank_list.precinct_filter.nil?
@phone_bank_list.build_municipal_district_filter if     @phone_bank_list.municipal_district_filter.nil?
			@phone_bank_list.build_voting_history_type_filter if @phone_bank_list.voting_history_type_filter.nil?
			  render :action => 'edit'
			end
		end
  end
  
  def destroy
  	if !@phone_bank_list.is_editable?
  		flash[:notice] = 'You can not delete this Phone Bank List while it is being populated.'
  		redirect_to @phone_bank_list
  		return
  	end
    @phone_bank_list.destroy
    flash[:notice] = "Successfully deleted Phone Bank List."
    redirect_to phone_bank_lists_url
  end
  
private

	#get the phone_bank_list for the current user
	def get_phone_bank_list
		begin
    @phone_bank_list = current_political_campaign.phone_bank_lists.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    	flash[:error] = "The requested Phone Bank List was not found."
    	redirect_back_or_default customer_control_panel_url
    end
	end

end

