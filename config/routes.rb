ActionController::Routing::Routes.draw do |map|

	map.root :controller => 'site'

	map.with_options(:controller => 'campaigns', :path_prefix => '/customer') do |site|
		site.unschedule_campaign 'unschedule_campaign/:id', :action => 'unschedule', :conditions => { :method => :get }
		site.resources :campaigns do |site2|
		end	
	end

	map.with_options(:controller => 'contact_lists', :path_prefix => '/customer') do |site|
		site.sex_filter_changed 'sex_filter_changed/:sex', :action => 'sex_filter_changed', :conditions => { :method => :get }
		site.age_filter_changed 'age_filter_changed/:min_age/:max_age', :action => 'age_filter_changed', :conditions => { :method => :get }
		site.party_filter_add 'party_filter_add/:party_id', :action => 'party_filter_add', :conditions => { :method => :get }
		site.party_filter_remove 'party_filter_remove/:party_id', :action => 'party_filter_remove', :conditions => { :method => :get }
		site.voting_history_type_filter_changed 'voting_history_type_filter_changed/:filter_type/:int_val', :action => 'voting_history_type_filter_changed', :conditions => { :method => :get }
		site.voting_history_filter_remove 'voting_history_filter_remove/:election_id', :action => 'voting_history_filter_remove', :conditions => { :method => :get }
		site.voting_history_filter_add 'voting_history_filter_add/:election_id/:vote_type', :action => 'voting_history_filter_add', :conditions => { :method => :get }
		site.current_voter_count 'current_voter_count.:format', :action => 'current_voter_count', :conditions => { :method => :get }
	end
	map.resources :contact_lists, :path_prefix => '/customer'

	map.admin_control_panel 'control_panel', :controller => 'admin', :action => 'index', :path_prefix => '/admin'

  map.resources :county_campaigns, :path_prefix => '/admin'

	map.customer_control_panel 'control_panel', :controller => 'customer', :action => 'index', :path_prefix => '/customer'

  map.resources :federal_campaigns, :path_prefix => '/admin'

	map.with_options(:controller => 'gis_regions', :path_prefix => '/customer') do |site|
		site.create_polygon 'create_polygon', :action => 'create', :conditions => { :method => [:post, :get] }
		site.add_vertices 'add_vertices', :action => 'add_vertices', :conditions => { :method => :post }
		site.count_in_poly 'count_in_poly', :action => 'count_in_poly', :conditions => { :method => :get }
		site.plot_precinct_cluster 'plot_precinct_cluster', :action => 'plot_precinct_cluster', :conditions => { :method => :get }
	end
	map.resources :gis_regions, :path_prefix => '/customer'

#	map.with_options(:controller => 'map') do |site|
#		site.map 'map', :action => 'index'
#		site.add_polygon 'add_polygon', :action => 'add_polygon', :conditions => { :method => [:post, :get] }
#		site.add_vertices 'add_vertices', :action => 'add_vertices', :conditions => { :method => [:post, :get] }
#	end

  map.resources :municipal_campaigns, :path_prefix => '/admin'

	map.resources :organizations, :path_prefix => '/admin'

	map.with_options(:controller => 'phone_bank_lists', :path_prefix => '/customer') do |site|
		site.resources :phone_bank_lists do |site2|
			site2.report 'report.:format', :controller => 'reports', :action => 'show', :conditions => { :method => :get }
		end	
	end

  map.resources :political_campaigns, :path_prefix => '/admin'

	#map.with_options(:controller => 'reports', :path_prefix => '/customer') do |site|
		#site.csv 'csv/:id', :action => 'csv_list', :conditions => { :method => :get }
		#site.pdf 'pdf/:id', :action => 'send_pdf_file', :conditions => { :method => :get }
	#end
	#map.resources :reports, :path_prefix => '/customer'

	map.with_options(:controller => 'robocall_campaigns', :path_prefix => '/customer') do |site|
		site.unschedule_robocall_campaign 'unschedule_robocall_campaign/:id', :action => 'unschedule', :conditions => { :method => :get }
		site.resources :robocall_campaigns do |site2|
			site2.report 'report.:format', :controller => 'reports', :action => 'show', :conditions => { :method => :get }
		end	
	end

	map.with_options(:controller => 'robocall_lists', :path_prefix => '/customer') do |site|
		site.intro 'intro', :action => 'intro', :conditions => { :method => :post }
		site.map_fields_robocall_list 'map_fields_robocall_list/:id', :action => 'map_fields', :conditions => { :method => [:get, :post] }
		site.resources :robocall_lists do |site2|
			site2.report 'report.:format', :controller => 'reports', :action => 'show', :conditions => { :method => :get }
		end	
	end

	map.with_options(:controller => 'sms_campaigns', :path_prefix => '/customer') do |site|
		site.unschedule_sms_campaign 'unschedule_sms_campaign/:id', :action => 'unschedule', :conditions => { :method => :get }
		site.resources :sms_campaigns do |site2|
			site2.report 'report.:format', :controller => 'reports', :action => 'show', :conditions => { :method => :get }
		end	
	end

	map.with_options(:controller => 'sms_lists', :path_prefix => '/customer') do |site|
		site.intro 'intro', :action => 'intro', :conditions => { :method => :post }
		site.map_fields_sms_list 'map_fields_sms_list/:id', :action => 'map_fields', :conditions => { :method => [:get, :post] }
		site.unschedule_sms_list 'unschedule_sms_list/:id', :action => 'unschedule', :conditions => { :method => :get }
		site.resources :sms_lists do |site2|
			site2.report 'report.:format', :controller => 'reports', :action => 'show', :conditions => { :method => :get }
		end	
	end
  #map.resources :sms_lists, :path_prefix => '/customer'

  map.resources :state_campaigns, :path_prefix => '/admin'

	#user signups and users resources
	map.with_options(:controller => 'users') do |site|
		site.signup 'signup', :action => 'new'
		site.thanks 'thanks', :action => 'thanks'
		site.precincts_populate 'precincts_populate/:parent/:id.:format', :action => 'precincts_populate', :conditions => { :method => :get }
		site.cd_populate 'cd_populate/:state_id.:format', :action => 'populate_cd_select', :conditions => { :method => :get }
		site.sd_populate 'sd_populate/:state_id.:format', :action => 'populate_sd_select', :conditions => { :method => :get }
		site.hd_populate 'hd_populate/:state_id.:format', :action => 'populate_hd_select', :conditions => { :method => :get }
		site.counties_populate 'counties_populate/:state_id.:format', :action => 'populate_counties_select', :conditions => { :method => :get }
		site.council_districts_populate 'council_districts_populate/:county_id.:format', :action => 'populate_council_districts_select', :conditions => { :method => :get }
		site.cities_populate 'cities_populate/:state_id.:format', :action => 'populate_cities_select', :conditions => { :method => :get }
		site.municipal_districts_populate 'municipal_districts_populate/:state_id/:city.:format', :action => 'populate_municipal_districts_select', :conditions => { :method => :get }
	end
	map.resources :users, :path_prefix => '/admin'

	# User Session URLs
	map.with_options(:controller => 'user_sessions') do |site|
		site.login 'login', :action => 'new', :url => '/login', :conditions => {:method => :get}
		site.login 'login', :action => 'create', :url => '/login', :conditions => {:method => :post}
		site.logout 'logout', :action => 'destroy', :url => '/logout'
	end

	map.with_options(:controller => 'validate_signup', :path_prefix => '/validate') do |site|
		site.validate_signup 'signup/:step_id.:format', :action => 'validate_signup', :conditions => { :method => :post }
	end

	map.with_options(:controller => 'walksheets', :path_prefix => '/customer') do |site|
		site.resources :walksheets do |site2|
			site2.report 'report.:format', :controller => 'reports', :action => 'show', :conditions => { :method => :get }
		end	
	end
  #map.resources :walksheets, :path_prefix => '/customer'

#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end
