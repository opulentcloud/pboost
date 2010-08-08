class RobocallCampaignsController < ApplicationController
	before_filter :require_user
	before_filter :get_robocall_campaign, :only => [:unschedule, :show, :edit, :update, :destroy]
	filter_access_to :all

	def unschedule
		if @robocall_campaign.status != 'Scheduled'
			flash[:error] = "We could not cancel the sending of this Campaign because the current status is #{@robocall_campaign.status}."
		else
			@robocall_campaign.scheduled_at = nil
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
		@robocall_campaign.user_name = current_user.full_name
		@robocall_campaign.user_ip_address = request.remote_ip

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
  		flash[:error] = 'You can not edit this Robocall Campaign at this time.'
  		redirect_to @robocall_campaign
  	end

		@robocall_campaign.acknowledgement = false #must acknowledge again.

    @robocall_campaign.build_live_answer_attachment unless !@robocall_campaign.live_answer_attachment.nil?
    @robocall_campaign.build_answer_machine_attachment unless !@robocall_campaign.answer_machine_attachment.nil?
  end
  
  def update
  	if !@robocall_campaign.is_editable?
  		flash[:error] = "You can not edit this Robocall Campaign because the current status is #{@robocall_campaign.status}."
  		redirect_to @robocall_campaign
  	end

		params[:robocall_campaign][:user_name] = current_user.full_name
		params[:robocall_campaign][:user_ip_address] = request.remote_ip

		notice = "Successfully scheduled Robocall Campaign."

		case params[:commit]
			when 'Send Campaign Now' then
				params[:robocall_campaign][:scheduled_at] = Time.zone.now
				params[:robocall_campaign].delete('scheduled_at(1i)')
				params[:robocall_campaign].delete('scheduled_at(2i)')
				params[:robocall_campaign].delete('scheduled_at(3i)')
				params[:robocall_campaign].delete('scheduled_at(4i)')
				params[:robocall_campaign].delete('scheduled_at(5i)')
				params[:robocall_campaign].delete('scheduled_at(6i)')
				params[:robocall_campaign].delete('scheduled_at(7i)')
				notice = 'Your Robocall Campaign will begin within the next hour.'
		end

		RobocallCampaign.transaction do
			if params[:robocall_campaign][:single_sound_file] == '1'
				if !@robocall_campaign.answer_machine_attachment.nil?
					@robocall_campaign.answer_machine_attachment.destroy
				end
				params[:robocall_campaign].delete(:answer_machine_attachments)
			end

			if @robocall_campaign.update_attributes(params[:robocall_campaign])
					flash[:notice] = notice
					redirect_to @robocall_campaign
			else
			  @robocall_campaign.build_live_answer_attachment unless !@robocall_campaign.live_answer_attachment.nil?
			  @robocall_campaign.build_answer_machine_attachment unless !@robocall_campaign.answer_machine_attachment.nil?

					render :action => 'edit'
			end

		end

  end
  
  def destroy
  	if !@robocall_campaign.is_deleteable?
  		flash[:notice] = 'You can not delete this Robocall Campaign at this time. &nbsp;You may be able to delete this campaign by unscheduling it if it is scheduled.'
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

