class UsersController < ApplicationController
	before_filter :require_user, :only => [:index, :show, :update, :destroy]
	before_filter :get_user, :only => [:show, :edit, :update, :destroy]
	before_filter :get_state, :only => [:populate_sd_select, :populate_hd_select, :populate_cd_select, :populate_counties_select, :populate_cities_select, :populate_municipal_districts_select, :precints_populate]
	filter_access_to [:show, :update, :index, :destroy, :edit]

  # PUT /users/1
  # PUT /users/1.xml
  def update

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit", :layout => 'admin' }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user.destroy

    respond_to do |format|
      flash[:notice] = 'User was successfully deleted.'
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

	def edit
		render :edit, :layout => 'admin'
	end

  # GET /users/1
  # GET /users/1.xml
  def show

    respond_to do |format|
      format.html { render :show, :layout => 'admin' }
      format.xml  { render :xml => @user }
    end
  end

  # GET /users
  # GET /users.xml
  def index
  	pg = params[:page] ||= 1
    @users = User.paginate :page => pg, :per_page => 10

    respond_to do |format|
      format.html { render :index, :layout => 'admin' }
      format.xml  { render :xml => @users }
    end
  end

	def precincts_populate
		@parent = params[:parent]
		@id = params[:id]
		@parent = 'none' if @id == '0'
		
		case @parent
			when 'none' then
				@precincts = current_political_campaign.precincts
			when 'cd' then
				@precincts = current_political_campaign.precincts.all(:conditions => "council_district_id = #{@id}")
			when 'mcomm_dist_code' then
				@precincts = current_political_campaign.precincts.all(:conditions => "municipal_district_id = #{@id}")
		end

		respond_to do |format|
			format.json { render :text => Precinct.to_json(@precincts) }
		end
		
	end

	def populate_municipal_districts_select
		@city = @state.cities.find_by_name(params[:city])
		@municipal_districts = @city.municipal_districts rescue nil
		@municipal_districts = MunicipalDistrict.all(:conditions => '1=0') if @municipal_districts.nil?
		respond_to do |format|
			format.json { render :text => MunicipalDistrict.to_json(@municipal_districts) }
		end
	end

	def populate_cities_select
		if params[:q].blank?
			@cities = @state.cities
		else
			@cities = @state.cities.all(:conditions => ['name like ?', params[:q] + '%'])
		end
		
		respond_to do |format|
			format.json { render :text => City.to_json(@cities) }
			format.js 
		end
	end	

	def populate_council_districts_select
		@county = County.find(params[:county_id].to_i)
		@council_districts = @county.council_districts
		respond_to do |format|
			format.json { render :text => CouncilDistrict.to_json(@council_districts) }
		end
	end

	def populate_counties_select
		@counties = @state.counties
		respond_to do |format|
			format.json { render :text => County.to_json(@counties) }
		end
	end	

	def populate_sd_select
		@sds = @state.senate_districts
		respond_to do |format|
			format.json { render :text => SenateDistrict.to_json(@sds) }
		end
	end

	def populate_hd_select
		@hds = @state.house_districts
		respond_to do |format|
			format.json { render :text => HouseDistrict.to_json(@hds) }
		end
	end

	def populate_cd_select
		@cds = @state.congressional_districts
		respond_to do |format|
			format.json { render :text => CongressionalDistrict.to_json(@cds) }
		end
	end

	def thanks
	end

	def new
		@user = User.new
		@user.build_organization.political_campaigns.build
		#@user.political_campaigns.build
	end

	def create
	#debugger
    @user = User.new(params[:user])
		@user.organization.account_type = AccountType.find_by_name('Pre-Pay')
		@user.roles << Role.find_by_name('Customer')
		@political_campaign = @user.organization.political_campaigns.first
		case params[:user][:organization_attributes][:political_campaigns_attributes]["0"][:type]	
		when 'FederalCampaign' then 
			@user.organization.federal_campaigns << FederalCampaign.create_from_political_campaign(@political_campaign)
		when 'StateCampaign' then 
			@user.organization.state_campaigns << StateCampaign.create_from_political_campaign(@political_campaign)
		when 'CountyCampaign' then 
			@user.organization.county_campaigns << CountyCampaign.create_from_political_campaign(@political_campaign)
		when 'MunicipalCampaign' then 
			@user.organization.municipal_campaigns << MunicipalCampaign.create_from_political_campaign(@political_campaign)
		end

		@user.organization.political_campaigns.first.destroy

		if @user.save
			flash.now[:notice] = 'Congratulations, your account has been created. We will notify you shortly when your account has been verified!'
			respond_to do |format|
				format.html {	redirect_to thanks_url }
				format.js
			end
		else
			respond_to do |format|
      	format.html { render :action => 'new' }
				format.js { 
					flash.now[:error] = @user.errors
					if @user.errors.nil?
						flash.now[:error] = @user.errors.add_to_base('Your account could not be created at this time.')
					end
					logger.debug(flash[:error].each_full { |msg| msg }.join('\n'))
					render :action => 'new' 
				}
    	end
    end

	end
	
	def signup
	end

private
	def get_state
		@state = State.find(params[:state_id].to_i)
	end

	def get_user
		begin
	    @user = User.find(params[:id])
	  rescue ActiveRecord::RecordNotFound
	  	flash.now[:error] = 'User record was not found.'
	  	@user = User.new
	  end   
	end 

end
