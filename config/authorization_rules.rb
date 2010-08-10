authorization do
	role :administrator do
		has_permission_on [:admin], :to => [:index]
		has_permission_on [:campaigns], :to => [:unschedule, :index, :new, :create, :edit, :show]
		has_permission_on [:categories], :to => [:index, :show, :new, :edit, :update, :create, :destroy]
		has_permission_on [:county_campaigns], :to => [:index, :show, :new, :edit, :update, :create, :destroy]
		has_permission_on [:federal_campaigns], :to => [:index, :show, :new, :edit, :update, :create, :destroy]
		has_permission_on [:gis_regions], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
		has_permission_on [:municipal_campaigns], :to => [:index, :show, :new, :edit, :update, :create, :destroy]
		has_permission_on [:products], :to => [:index, :show, :new, :edit, :update, :create, :destroy]
		has_permission_on [:political_campaigns], :to => [:index, :show, :new, :edit, :update, :create, :destroy]
		has_permission_on [:robocall_campaigns], :to => [:unschedule, :index, :show, :new, :create, :edit, :update, :destroy]
		has_permission_on [:state_campaigns], :to => [:index, :show, :new, :edit, :update, :create, :destroy]
		has_permission_on [:organizations], :to => [:index, :show, :new, :edit, :update, :create, :destroy]
		has_permission_on [:users], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
		has_permission_on [:walksheets], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
	end

	role :customer do
		has_permission_on [:campaigns], :to => [:unschedule, :index, :new, :create, :edit, :show]
		has_permission_on [:carts], :to => [:show]
		has_permission_on :contact_lists, :to => [:age_filter_changed, :sex_filter_changed, :party_filter_add, :party_filter_remove, :voting_history_type_filter_changed, :voting_history_filter_remove, :voting_history_filter_add, :current_voter_count]
		has_permission_on :customer, :to => [:index]
		has_permission_on [:gis_regions], :to => [:plot_precinct_cluster, :count_in_poly, :add_vertices, :index, :show, :new, :create, :edit, :update, :destroy]
		has_permission_on [:phone_bank_lists], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
		has_permission_on [:robocall_campaigns], :to => [:unschedule, :index, :show, :new, :create, :edit, :update, :destroy]
		has_permission_on [:robocall_lists], :to => [:map_fields, :intro, :index, :show, :new, :create, :edit, :update, :destroy]
		has_permission_on [:sms_campaigns], :to => [:get_price, :unschedule, :index, :show, :new, :create, :edit, :update, :destroy]
		has_permission_on [:sms_lists], :to => [:map_fields, :intro, :unschedule, :index, :show, :new, :create, :edit, :update, :destroy]
		has_permission_on [:walksheets], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
	end
	
	role :guest do
		has_permission_on :member, :to => [:join, :register, :resend]
		has_permission_on :site, :to => [:unauthorized, :index, :show_page]
	end
	
end

