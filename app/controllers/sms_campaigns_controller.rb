class SmsCampaignsController < ApplicationController
	before_filter :require_user
	before_filter :get_sms_campaign, :only => [:unschedule, :show, :edit, :update, :destroy]
	filter_access_to :all
	ssl_required :unschedule, :index, :show, :new, :create, :edit, :destroy
	
	def unschedule
		if @sms_campaign.status != 'Scheduled'
			flash[:error] = "We could not cancel the sending of this Campaign because the current status is #{@sms_campaign.status}."
		else
			@sms_campaign.scheduled_at = nil
			if @sms_campaign.save
				flash[:notice] = 'Unschedule was successful.'
			else
				flash[:error] = 'We could not unschedule at this time.'
			end
		end
		redirect_back_or_default campaigns_path
	end

  def show
  end
  
  def new
		if current_political_campaign.populated == false
			flash[:error] = 'You can not add a Campaign until we have finished populating your Political Campaign Voters'
			redirect_to campaigns_path
			return
		end

    @sms_campaign = current_political_campaign.sms_campaigns.build
  end
  
  def create
    @sms_campaign = SmsCampaign.new(params[:sms_campaign])
		@sms_campaign.user_name = current_user.full_name
		@sms_campaign.user_ip_address = request.remote_ip
		@sms_campaign.populated = false

		notice = 'Your SMS Campaign is being scheduled.'

		case params[:commit]
			when 'Send Campaign Now' then
				@sms_campaign.scheduled_at = Time.zone.now
				notice = 'Your SMS Campaign is being sent.'
		end

	  if @sms_campaign.save
	    flash[:notice] = notice
			respond_to do |format|
				format.html { redirect_to @sms_campaign }
				format.js
			end
	  else
			respond_to do |format|
      	format.html { render :action => 'new' }
    	end
	  end
  end
  
  def edit
  	if !@sms_campaign.is_editable?
  		flash[:error] = 'You can not edit this SMS Campaign at this time.'
  		redirect_to @sms_campaign
  	end

		@sms_campaign.acknowledgement = false #must acknowledge again.
  end
  
  def update
  	if !@sms_campaign.is_editable?
  		flash[:error] = "You can not edit this SMS Campaign because the current status is #{@sms_campaign.status}."
  		redirect_to @sms_campaign
  	end

		params[:sms_campaign][:user_name] = current_user.full_name
		params[:sms_campaign][:user_ip_address] = request.remote_ip

		notice = 'Your SMS Campaign has been scheduled.'

		case params[:commit]
			when 'Send Campaign Now' then
				params[:sms_campaign][:scheduled_at] = Time.zone.now
				params[:sms_campaign].delete('scheduled_at(1i)')
				params[:sms_campaign].delete('scheduled_at(2i)')
				params[:sms_campaign].delete('scheduled_at(3i)')
				params[:sms_campaign].delete('scheduled_at(4i)')
				params[:sms_campaign].delete('scheduled_at(5i)')
				params[:sms_campaign].delete('scheduled_at(6i)')
				params[:sms_campaign].delete('scheduled_at(7i)')
				notice = 'Your SMS Campaign is being sent.'
		end

		if @sms_campaign.update_attributes(params[:sms_campaign])
				flash[:notice] = notice
				redirect_to @sms_campaign
		else
				render :action => 'edit'
		end

  end
  
  def destroy
  	if !@sms_campaign.is_deleteable?
  		flash[:notice] = 'You can not delete this SMS Campaign at this time. &nbsp;You may be able to delete this campaign by unscheduling it if it is scheduled.'
  		redirect_to @sms_campaign
  		return
  	end
    if @sms_campaign.destroy
    	flash[:notice] = "Successfully deleted SMS Campaign."
    else
    	flash[:error] = 'We could not delete this SMS Campaign at this time.'
    end
    redirect_to campaigns_url
  end

private

	#get the sms campaign for the current user
	def get_sms_campaign
		begin
    @sms_campaign = current_political_campaign.sms_campaigns.find(params[:id]) unless current_political_campaign.nil?
	    if current_political_campaign.nil? && current_user.is_admin?
		    @sms_campaign = Campaign.find(params[:id])
		    session[:current_political_campaign] = @sms_campaign.political_campaign
			end    
    rescue ActiveRecord::RecordNotFound
    	flash[:error] = "The requested SMS Campaign was not found."
    	redirect_back_or_default customer_control_panel_url
    end
	end

end

