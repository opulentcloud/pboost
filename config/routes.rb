ActionController::Routing::Routes.draw do |map|

	map.root :controller => 'site'

	map.with_options(:controller => 'validate_signup', :path_prefix => '/validate') do |site|
		site.validate_signup 'signup/:step_id.:format', :action => 'validate_signup', :conditions => { :method => :post }
	end

	# User Session URLs
	map.with_options(:controller => 'user_sessions') do |site|
		site.login 'login', :action => 'new', :url => '/login', :conditions => {:method => :get}
		site.login 'login', :action => 'create', :url => '/login', :conditions => {:method => :post}
		site.logout 'logout', :action => 'destroy', :url => '/logout'
	end

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
	end
	map.resources :users

	map.customer_control_panel 'control_panel', :controller => 'customer', :action => 'index', :path_prefix => '/customer'

#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end
