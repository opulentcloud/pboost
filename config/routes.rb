ActionController::Routing::Routes.draw do |map|

	map.root :controller => 'site'

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
	end
	map.resources :users

	map.customer_control_panel 'control_panel', :controller => 'customer', :action => 'index', :path_prefix => '/customer'

#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end
