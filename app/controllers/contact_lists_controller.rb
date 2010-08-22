class ContactListsController < ApplicationController
	before_filter :require_user, :get_session_filters
	after_filter :save_session_filters
	filter_access_to :all
	ssl_required :current_voter_count, :voting_history_filter_remove, :voting_history_filter_add, :party_filter_add, :party_filter_remove, :age_filter_changed, :sex_filter_changed
	
	def current_voter_count
	#debugger
		@vertices = params[:vertices]
		@filters[:list_type] = params[:list_type]
		
		if @vertices
			r = GisRegion.new()
			r.name = 'temp'
			r.vertices = @vertices
			r.valid?
			if r.geom2
				@filters[:geom] = r.geom2.as_hex_ewkb
			end
		end
		
		@current_voter_count = current_political_campaign.potential_voters_count(@filters)
		
		respond_to do |format|
			format.html { }
			format.js { }
		end
	end

	def voting_history_filter_remove
		voting_history_filters = @filters[:voting_history_filters] ||= []
		voting_history_filters.each do |vhf|
			if vhf.id == params[:election_id].to_i
				voting_history_filters.delete(vhf)
				break
			end
		end
		@filters[:voting_history_filters] = voting_history_filters
	
		render :partial => '/shared/blank', :layout => false
	end

	def voting_history_filter_add
		voting_history_filters = @filters[:voting_history_filters] ||= []
		e = Election.find(params[:election_id].to_i)
		e.query_vote_type = params[:vote_type]

		voting_history_filters.each do |vhf|
			if vhf.id == e.id
				voting_history_filters.delete(e)
				break
			end
		end

		voting_history_filters.push(e)
		
		@filters[:voting_history_filters] = voting_history_filters
		@filters[:filter_type] = 'Any' if @filters[:filter_type].blank?
		@filters[:filter_type_int_val] = 1 if @filters[:filter_type_int_val].blank?

		render :partial => '/shared/blank', :layout => false
	end

	def voting_history_type_filter_changed
		@filters[:filter_type] = params[:filter_type]
		@filters[:filter_type_int_val] = params[:int_val].to_i

		render :partial => '/shared/blank', :layout => false
	end

	def party_filter_add
		party_filters = @filters[:party_filters] ||= ''
		if party_filters.length > 0
			party_filters += ','+params[:party_id]
		else
			party_filters = params[:party_id]
		end
		@filters[:party_filters] = party_filters
		
		render :partial => '/shared/blank', :layout => false
	end

	def party_filter_remove
		party_filters = @filters[:party_filters] ||= ''
		new_party_filters = ''
		if party_filters.size > 0
			party_filters.split(',').each do |a|
				next if a == params[:party_id]
				if new_party_filters.length > 0
					new_party_filters += ',' + a
				else
					new_party_filters += a
				end
			end
		end	
		@filters[:party_filters] = new_party_filters
		
		render :partial => '/shared/blank', :layout => false
	end

	def age_filter_changed
		@filters[:min_age] = params[:min_age].to_i
		@filters[:max_age] = params[:max_age].to_i
		#fix any strange problems
		if @filters[:max_age] < @filters[:min_age]
			if @filters[:max_age] == 0
				@filters[:max_age] = 109 
			else
				@filters[:max_age] = @filters[:min_age]
			end
		end
		
		if @filters[:min_age] == 0 && @filters[:max_age] == 0
			@filters.delete(:min_age)
			@filters.delete(:max_age)
		end
		
		render :partial => '/shared/blank', :layout => false
	end

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
