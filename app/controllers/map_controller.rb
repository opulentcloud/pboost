class MapController < ApplicationController
	#this automatically populates session[:geo_location]
	#with a GeoLoc object based on visitors ip address
	geocode_ip_address
	before_filter :check_geo_location

  def index
		@session_key = UUIDTools::UUID.timestamp_create
  end  

	def add_polygon
		logger.debug(params)
		if request.post?
			p params[:name]
			p params[:vertices]
			
			#save model here
			
			#send javascript back to update the map
			run_javascript do |script|
				map = script.map
				#map.add_polygon :vertices => params[:vertices]
				map.update_info_window :html => 'You have added a new GIS Region!'
			end
		else
			session[:vertices] = params[:vertices]
		end
	end

	def add_vertex
		logger.debug(params)
		if request.post?
			p params[:name]
			p params[:vertices]
			
			#save model here
			
			#send javascript back to update the map
			run_javascript do |script|
				map = script.map
				#map.add_polygon :vertices => params[:location]
				map.update_info_window :html => 'You have added a new GIS Region!'
			end
		end

	end

	def add_marker
		if request.post?
			p params[:name]
			p params[:location]
			
			#save model here
			
			#send javascript back to update the map
			run_javascript do |script|
				map = script.map
				map.add_marker :location => params[:location]
				map.update_info_window :html => 'You have added a new marker!'
			end
		end
	end
  
private
 
 	#if we could not find a good location, just set our default.
	def check_geo_location
  	session[:geo_location] ||= GeoKit::GeoLoc.new(:lat => 39.3597710000, :lng => -76.6716720000, :city => 'Baltimore')
	end

  
end
