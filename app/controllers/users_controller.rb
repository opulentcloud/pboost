class UsersController < ApplicationController

	def thanks
	end

	def new
		@user = User.new
		@user.build_organization.political_campaigns.build
		#@user.political_campaigns.build
	end

	def create
    @user = User.new(params[:user])
		@user.organization.account_type = AccountType.find_by_name('Pre-Pay')
		@user.roles << Role.find_by_name('Customer')
		@political_campaign = @user.organization.political_campaigns.first
		case params[:user][:organization_attributes][:political_campaigns_attributes]["0"][:type]	
		when 'FederalCampaign' then 
			@user.organization.federal_campaigns << FederalCampaign.create_from_political_campaign(@political_campaign)
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
					logger.debug(flash[:error])
					render :action => 'new' 
				}
    	end
    end

	end
	
	def signup
	end

end
