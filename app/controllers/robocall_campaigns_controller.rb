class RobocallCampaignsController < ApplicationController
	before_filter :require_user
	before_filter :get_robocall_campaign, :only => [:unschedule, :show, :edit, :update, :destroy]
	filter_access_to :all

	def unschedule
		if @robocall_campaign.status != 'Scheduled'
			flash[:error] = "We could not cancel the sending of this Campaign because the current status is #{@robocall_campaign.status}."
		else
			@robocall_campaign.schedule_at = nil
			if @robocall_campaign.save
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

    @robocall_campaign = current_political_campaign.robocall_campaigns.build
    @robocall_campaign.build_live_answer_attachment
    @robocall_campaign.build_answer_machine_attachment
  end
  
  def create
    @robocall_campaign = RobocallCampaign.new(params[:robocall_campaign])

		notice = 'Your Robocall Campaign has been scheduled.'

		case params[:commit]
			when 'Send Campaign Now' then
				@robocall_campaign.scheduled_at = Time.zone.now
				notice = 'Your Robocall Campaign will begin within the next hour.'
		end

	  if @robocall_campaign.save
	    flash[:notice] = notice
			respond_to do |format|
				format.html { redirect_to @robocall_campaign }
				format.js
			end
	  else
	    @robocall_campaign.build_live_answer_attachment if @robocall_campaign.live_answer_attachment.nil?
	    @robocall_campaign.build_answer_machine_attachment if @robocall_campaign.answer_machine_attachment.nil?

			if @robocall_campaign.live_answer_attachment
				logger.debug(@robocall_campaign.live_answer_attachment.content_type)
			else
				logger.debug("no attachment")
			end

			respond_to do |format|
      	format.html { render :action => 'new' }
    	end
	  end
  end
  
  def edit
  	if !@robocall_campaign.is_editable?
  		flash[:error] = 'You can not edit this Robocall Campaign while it is being populated.'
  		redirect_to @robocall_campaign
  	end
  	
  	if !@robocall_campaign.status == 'n/a'
  		flash[:error] = "You can not edit this Robocall Campaign because the current status is #{@robocall_campaign.status}."
  		redirect_to @robocall_campaign
  	end

  end
  
  def update
  	if !@robocall_campaign.status == 'n/a'
  		flash[:error] = "You can not edit this Robocall Campaign because the current status is #{@robocall_campaign.status}."
  		redirect_to @robocall_campaign
  	end

		if @robocall_campaign.update_attributes(params[:robocall_campaign])
			  flash[:notice] = "Successfully scheduled Robocall Campaign."
			  redirect_to @robocall_campaign
		else
			  render :action => 'edit'
		end

  end
  
  def destroy
  	if !@robocall_campaign.is_editable?
  		flash[:notice] = 'You can not delete this Robocall Campaign while it is being populated.'
  		redirect_to @robocall_campaign
  		return
  	end
    @robocall_campaign.destroy
    flash[:notice] = "Successfully deleted Robocall Campaign."
    redirect_to campaigns_url
  end
  
private

	#get the robocall campaign for the current user
	def get_robocall_campaign
		begin
    @robocall_campaign = current_political_campaign.robocall_campaigns.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    	flash[:error] = "The requested Robocall Campaign was not found."
    	redirect_back_or_default customer_control_panel_url
    end
	end

end

