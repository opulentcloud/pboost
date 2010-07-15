class ContactListsController < ApplicationController
	before_filter :require_user, :get_session_filters
	after_filter :save_session_filters
	filter_access_to :all

	def sex_filter_changed
		@filters[:sex] = params[:sex] unless params[:sex] == 'A'
		@filters.delete(:sex) if params[:sex] == 'A'
		render :partial => '/shared/blank', :layout => false
	end
  
private

	#get the contact_list for the current user
	def get_contact_list
		begin
    @contact_list = current_political_campaign.contact_lists.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    	flash[:error] = "The requested Contact List was not found."
    	redirect_back_or_default customer_control_panel_url
    end
	end

	def get_session_filters
		@sess_id = params[:sess_id]
		@filters = session[(@sess_id+'_filters').to_sym] ||= Hash.new()
	end

	def save_session_filters
		session[(@sess_id+'_filters').to_sym] = @filters
	end
end
