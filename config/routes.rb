ActionController::Routing::Routes.draw do |map|

	map.root :controller => 'site'

	map.admin_control_panel 'control_panel', :controller => 'admin', :action => 'index', :path_prefix => '/admin'

  map.resources :county_campaigns, :path_prefix => '/admin'

	map.customer_control_panel 'control_panel', :controller => 'customer', :action => 'index', :path_prefix => '/customer'

  map.resources :federal_campaigns, :path_prefix => '/admin'

	map.with_options(:controller => 'gis_regions', :path_prefix => '/customer') do |site|
		site.create_polygon 'create_polygon', :action => 'create', :conditions => { :method => [:post, :get] }
		site.add_vertices 'add_vertices', :action => 'add_vertices', :conditions => { :method => :post }
	end
	map.resources :gis_regions, :path_prefix => '/customer'

#	map.with_options(:controller => 'map') do |site|
#		site.map 'map', :action => 'index'
#		site.add_polygon 'add_polygon', :action => 'add_polygon', :conditions => { :method => [:post, :get] }
#		site.add_vertices 'add_vertices', :action => 'add_vertices', :conditions => { :method => [:post, :get] }
#	end

  map.resources :municipal_campaigns, :path_prefix => '/admin'

	map.resources :organizations, :path_prefix => '/admin'

  map.resources :political_campaigns, :path_prefix => '/admin'

	map.with_options(:controller => 'reports', :path_prefix => '/customer') do |site|
		site.csv 'csv/:id', :action => 'csv_list', :conditions => { :method => :get }
		site.pdf 'pdf/:id', :action => 'send_pdf_file', :conditions => { :method => :get }
	end
	map.resources :reports, :path_prefix => '/customer'

  map.resources :state_campaigns, :path_prefix => '/admin'

	#user signups and users resources
	map.with_options(:controller => 'users') do |site|
		site.signup 'signup', :action => 'new'
		site.thanks 'thanks', :action => 'thanks'
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

  map.resources :walksheets, :path_prefix => '/customer'

#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end
