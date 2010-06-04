class UsersController < ApplicationController
	before_filter :get_state, :only => [:populate_sd_select, :populate_hd_select, :populate_cd_select, :populate_counties_select, :populate_cities_select]

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
		#@user.organization.political_campaigns.first.type = params[:user][:organization_attributes][:political_campaigns_attributes]["0"][:type]
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
					flash.now[:error] = @user.errors.each_full { |m| puts "#{m}" }.join('<br />')
					if flash[:error].blank?
						flash[:error] = "Your account could not be created at this time."
					end
					logger.debug(flash[:error])
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

end
